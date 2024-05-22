# Qtile modules
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import importlib

import psutil

# Force reload all custom modules
import theme; importlib.reload(theme)
import commands; importlib.reload(commands)
import screencast; importlib.reload(screencast)

# Import from custom modules
from theme import *
from commands import CommandRepository, load_commands

from dataclasses import dataclass, field
from typing import List, Callable


@dataclass
class WorkSpace:
    name: str
    navigation_keys: List[str]
    matches: List[Match] = field(default_factory=list)
    on_enter_callbacks: List[Callable] = field(default_factory=list)


@dataclass
class ScratchPadItem:
    name: str
    cmd: str

    hotkeys: List[str]

    width: float = 0.35
    height: float = 0.4

    x: float = 0.325
    y: float = 0.3

    opacity: float = 1.0


def load_workspaces():
    return [
        *[
            WorkSpace("\u26ac" + "\u200b"*i, [str(i)])
            for i in range(1, 5)
        ],
        WorkSpace("\uf075", ["c", "5"], [
            Match(wm_class=["telegram-desktop"]),
            Match(wm_class=["discord"]),
        ]),
        WorkSpace("\uf013", ["s", "6"]),
    ]


def load_scratchpad_items() -> List[ScratchPadItem]:
    return [
        ScratchPadItem("term", "kitty", ["M-d M-t"]),
    ]


def load_scratchpad(scratchpad_items) -> List[ScratchPadItem]:
    return ScratchPad("scratchpad", [
        DropDown(item.name, item.cmd, width=item.width, height=item.height, x=item.x, y=item.y, opacity=item.opacity)
        for item in scratchpad_items
    ])


def load_groups(workspaces: List[WorkSpace]):
    return [Group(ws.name, matches=ws.matches) for ws in workspaces]


def load_keys(workspaces, scratchpad_items):
    command_repo = CommandRepository()
    commands = load_commands(command_repo, workspaces, scratchpad_items)
    command_repo.extend(commands)
    return command_repo.build_hotkeys()


def load_mouse():
    mod = "mod4"
    return [
        Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
        Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
        Click([mod], "Button2", lazy.window.bring_to_front()),
    ]


def load_screens():
    active_setup = []

    if screencast.is_screencast_mode():
        active_setup = [
            Screen(x=0, y=0, width=1920, height=1080),
            Screen(x=1920, y=0, width=640, height=1080),
        ]
    else:
        active_setup = [
            Screen(top=top_bar(), x=0, y=0, width=3840, height=2160),
        ]

    return active_setup


def load_extension_defaults():
    return dict(
        padding=3,
        **theme.primary_font,
        foreground=COLOR_WIDGET_FONT,
    )


def load_widget_defaults():
    return dict(
        padding=3,
        **theme.primary_font,
        foreground=COLOR_WIDGET_FONT,
    )


def load_layouts():
    return [
        layout.Columns(
            border_focus=COLOR_BORDER_FOCUS, 
            border_normal=COLOR_BORDER_NORMAL, 
            border_width=2,
        ),
        layout.Max(),
    ]


def widget_sep_generic(text: str):
    return widget.TextBox(
        text = text,
        padding = 0,
        fontsize = 24,
        foreground = COLOR_WIDGET_BACKGROUND_PRIMARY,
    )


def widget_sep_primary():
    return widget_sep_generic(" ")


def widget_sep_secondary():
    return widget_sep_generic(" ")


def widget_left_end():
    return widget_sep_generic(" ")


def widget_right_end():
    return widget_sep_generic(" ")


def bottom_bar():
    return bar.Bar(
        [
            widget.Spacer(),
            widget_left_end(),
            widget.TaskList(
                borderwidth=1,
                font=FONT_NAME,
                fontsize=FONT_SIZE,
                highlight_method="block",
                background=COLOR_WIDGET_BACKGROUND_PRIMARY,
                foreground=COLOR_WIDGET_FOREGROUND_PRIMARY,
                border=COLOR_WIDGET_BACKGROUND_SECONDARY,
                max_title_width=150,
                rounded=False,
            ),
            widget_right_end(),
            widget.Spacer(),
        ],
        **theme.panel_bar,
    )


def top_bar():
    return bar.Bar([
            widget.Spacer(),
            widget_left_end(),
            widget.GroupBox(
                borderwidth=1,
                active=COLOR_WS_ACTIVE,
                inactive=COLOR_WS_INACTIVE,
                this_current_screen_border=COLOR_CURRENT_SCREEN_BACKGROUND,
                this_screen_border=COLOR_OTHER_SCREEN_BACKGROUND,
                other_current_screen_border=COLOR_OTHER_SCREEN_BACKGROUND,
                other_screen_border=COLOR_OTHER_SCREEN_BACKGROUND,
                background=COLOR_GROUP_BOX_BACKGROUND,
                highlight_method="block",
                rounded=False,
            ),
            widget_right_end(),
            widget.Spacer(),
            widget_sep_primary(),
            widget.TextBox(
                text="\uf028", 
                **theme.icon_font,
                **theme.alternate_colors,
            ),
            widget.Volume(
                **theme.alternate_colors,
            ),
            widget_sep_primary(),
            widget.Clock(
                format="%I:%M %p",
                **theme.primary_colors,
            ),
        ],
        **theme.panel_bar)

def load_floating_layout():
    return layout.Floating(
        float_rules=[
            # Run the utility of `xprop` to see the wm class and name of an X client.
            # *layout.Floating.default_float_rules,
            Match(wm_type="dialog"),
            Match(wm_class="pinentry-gtk-2"),
            Match(wm_class="ranger-file-picker"),
            Match(wm_class="Emulator"),
            Match(wm_class="term-popup"),
            Match(wm_class="Toolkit"),
        ]
    )

