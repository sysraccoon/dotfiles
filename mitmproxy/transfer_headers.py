import pickle
import base64

from collections.abc import Sequence
from typing import Tuple
from mitmproxy import ctx, http, command, flow
from typing import List
from pathlib import Path


HEADER_BUFFER_FILE = Path("/tmp/mitmproxy_transfer_headers.pickle")
URL_BUFFER_FILE = Path("/tmp/mitmproxy_transfer_url.pickle")
BODY_BUFFER_FILE = Path("/tmp/mitmproxy_transfer_body.pickle")
GRIDVIEW_BUFFER_FILE = Path("/tmp/mitmproxy_transfer_grideditor.pickle")

def load(l):
    ctx.master.keymap.add(
        "y", 
        """
        console.choose.cmd Yank transfer.yank_types
        transfer.yank {choice} @focus
        """,
        ["flowlist", "flowview"],
        "Yank flow data to temporary buffer",
    )

    ctx.master.keymap.add(
        "p",
        """
        console.choose.cmd Paste transfer.paste_types
        transfer.paste {choice} @focus
        """,
        ["flowlist", "flowview"],
        "Paste flow data from temporary buffer",
    )

    ctx.master.keymap.add(
        "y", 
        "transfer.yank_grideditor_row",
        ["grideditor"],
        "Yank row under cursor to temporary buffer",
    )

    ctx.master.keymap.add(
        "p",
        "transfer.paste_below_grideditor_row",
        ["grideditor"],
        "Paste row after current cursor",
    )

    ctx.master.keymap.add(
        "P",
        "transfer.paste_under_grideditor_row",
        ["grideditor"],
        "Paste row before current cursor",
    )


@command.command("transfer.yank_grideditor_row")
def yank_grideditor_row():
    editor = _grideditor()    
    walker = editor.walker
    items = walker.lst
    focus = walker.focus

    focus_row = items[focus][0]
    _yank_grid_row(focus_row)


@command.command("transfer.paste_below_grideditor_row")
def paste_below_grideditor_row():
    row = _paste_grid_row()
    _insert_grid_row_with_offset(row, offset=1)


@command.command("transfer.paste_under_grideditor_row")
def paste_under_grideditor_row():
    row = _paste_grid_row()
    _insert_grid_row_with_offset(row, offset=0)


def _insert_grid_row_with_offset(row, offset=0):
    if not row:
        return

    editor = _grideditor()
    walker = editor.walker
    _insert_grid_row(walker, min(walker.focus + offset, len(walker.lst)), row)


def _insert_grid_row(walker, row_index, values=None):
    if not values:
        values = [c.blank() for c in walker.editor.columns]
    walker.focus = row_index
    walker.lst.insert(row_index, (values, set()))
    walker.focus_col = 0
    walker._modified()


@command.command("transfer.yank_url")
def yank_url(flow: flow.Flow):
    _yank_url(flow.request.url)


@command.command("transfer.paste_url")
def paste_url(flow: flow.Flow):
    flow.request.url = _paste_url()


@command.command("transfer.yank_request_headers")
def yank_request_headers(flow: flow.Flow):
    _yank_headers(flow.request.headers)


@command.command("transfer.yank_response_headers")
def yank_response_headers(flow: flow.Flow):
    _yank_headers(flow.response.headers)


@command.command("transfer.paste_request_headers")
def paste_request_headers(flow: flow.Flow):
    flow.request.headers = _paste_headers()


@command.command("transfer.paste_response_headers")
def paste_response_headers(flow: flow.Flow):
    flow.response.headers = _paste_headers()


transfer_yank_commands = {
    "request.url": yank_url,
    "request.headers": yank_request_headers,
    "response.headers": yank_response_headers,
}

@command.command("transfer.yank")
def yank(yank_type: str, flow: flow.Flow):
    transfer_yank_commands[yank_type](flow)


transfer_paste_commands = {
    "request.url": paste_url,
    "request.headers": paste_request_headers,
    "response.headers": paste_response_headers,
}

@command.command("transfer.paste")
def paste(paste_type: str, flow: flow.Flow):
    transfer_paste_commands[paste_type](flow)


@command.command("transfer.yank_types")
def yank_types() -> Sequence[str]:
    return list(transfer_yank_commands.keys())


@command.command("transfer.paste_types")
def paste_types() -> Sequence[str]:
    return list(transfer_paste_commands.keys())


def _grideditor():
    gewidget = ctx.master.window.current("grideditor")
    if not gewidget:
        raise exceptions.CommandError("Not in a grideditor.")
    return gewidget.key_responder()


def _yank_grid_row(row: Tuple):
    _save_to_buffer(GRIDVIEW_BUFFER_FILE, row)


def _paste_grid_row() -> Tuple:
    return _load_from_buffer(GRIDVIEW_BUFFER_FILE)


def _yank_url(url: str):
    _save_to_buffer(URL_BUFFER_FILE, url, str)


def _paste_url() -> str:
    return _load_from_buffer(URL_BUFFER_FILE, str)


def _yank_headers(headers: http.Headers):
    _save_to_buffer(HEADER_BUFFER_FILE, headers.fields)
    

def _paste_headers() -> http.Headers:
    return _load_from_buffer(HEADER_BUFFER_FILE, transform=http.Headers)


def _save_to_buffer(buffer, value, transform=None):
    with buffer.open("wb") as f:
        target = value
        if transform:
            target = transform(value)
        pickle.dump(target, f)


def _load_from_buffer(buffer, transform=None):
    with buffer.open("rb") as f:
        target = pickle.load(f)
        if transform:
            return transform(target)
        return target
