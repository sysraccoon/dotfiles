import subprocess
import tempfile
import os
import stat

import threading
from collections.abc import Sequence
from mitmproxy import ctx, http, command, flow
from mitmproxy.tools.console import signals


def load(l):
    ctx.master.keymap.add(
        "J", 
        """
        console.choose.cmd Yank json_viewer.content_source_types
        json_viewer.view_from {choice} @focus
        """,
        ["flowlist", "flowview"],
        "Open body inside external json viewer",
    )


@command.command("json_viewer.view_request_body")
def view_request_body(flow: flow.Flow):
    content = flow.request.text
    view_generic(content)


@command.command("json_viewer.view_response_body")
def view_response_body(flow: flow.Flow):
    content = flow.response.text
    view_generic(content)


content_source_commands = {
    "request.body": view_request_body,
    "response.body": view_response_body,
}


@command.command("json_viewer.content_source_types")
def content_source_types() -> Sequence[str]:
    return list(content_source_commands.keys())


@command.command("json_viewer.view_from")
def view_from(content_source_type: str, flow: flow.Flow):
    return content_source_commands[content_source_type](flow)


def view_generic(content: str):
    ext = ".json"
    fd, name = tempfile.mkstemp(ext, "mproxy")
    try:
        os.write(fd, content.encode("UTF-8"))
    finally:
        os.close(fd)

    # read-only to remind the user that this is a view function
    os.chmod(name, stat.S_IREAD)

    with ctx.master.uistopped():
        try:
            subprocess.call(["jless", name], shell=False)
        except Exception as e:
            signals.status_message.send(message="Can't open json viewer: %s" % str(e))

    # add a small delay before deletion so that the file is not removed before being loaded by the viewer
    t = threading.Timer(1.0, os.unlink, args=[name])
    t.start()

