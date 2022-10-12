# Qtile modules
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import importlib

import psutil

# Force reload all custom modules
import theme; importlib.reload(theme)
import commands; importlib.reload(commands)

# Import from custom modules
from theme import *
from commands import CommandRepository, load_commands


def load_group_names():
    return [
        "sys",  # generic wm for terminals
        "dev",  # development software (pycharm, idea, etc.)
        "net",  # network analysis (mitm, wireshark, etc.)
        "rev",  # reverse specific (ida, ghidra, etc.)
        "www",  # web surfing (qutebrowser, firefox, etc.)
        "msg",  # apps for communication (telegram, slack, etc.)
        "vid",  # multimedia (mvp)
        *[
            f"{i}.gen" for i in range(1, 4)
        ] # generic wms
    ]


def load_groups(group_names):
    groups = []
    matches_map = {
        "www": [
            Match(wm_class=["qutebrowser"]),
            Match(wm_class=["firefox"]),
        ],
        "dev": [
            Match(wm_class=["jetbrains-pycharm-ce"]),
            Match(wm_class=["jetbrains-idea-ce"]),
        ],
        "msg": [
            Match(wm_class=["telegram-desktop"]),
            Match(wm_class=["discord"]),
        ],
        "vid": [
            Match(wm_class=["mpv"]),
        ],
    }

    for group_name in group_names:
        matches = matches_map.get(group_name, [])
        group = Group(group_name, matches=matches)
        groups.append(group)
    return groups


def load_keys(group_names):
    command_repo = CommandRepository()
    commands = load_commands(command_repo, group_names)
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
    return [
        Screen(top=top_bar(), bottom=bottom_bar()),
        Screen(top=top_bar()),
    ]


def load_extension_defaults():
    return dict(
        font=FONT_NAME,
        fontsize=FONT_SIZE,
        padding=3,
        foreground=COLOR_WIDGET_FONT,
    )


def load_widget_defaults():
    return dict(
        font=FONT_NAME,
        fontsize=FONT_SIZE,
        padding=3,
        foreground=COLOR_WIDGET_FONT,
    )


def load_layouts():
    return [
        layout.Columns(
            border_focus=COLOR_BORDER_FOCUS, 
            border_normal=COLOR_BORDER_NORMAL, 
            border_width=2
        ),
        layout.Max(),
    ]


def widget_sep_primary():
    return widget.TextBox(
       text = "\ue0be",
       padding = 0,
       fontsize = 24,
       foreground=COLOR_WIDGET_BACKGROUND_PRIMARY
   )


def widget_sep_secondary():
    return  widget.TextBox(
       text = "\ue0b8",
       padding = 0,
       fontsize = 24,
       foreground=COLOR_WIDGET_BACKGROUND_PRIMARY,
   )


def bottom_bar():
    return bar.Bar(
       [
            widget.Spacer(),
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
            widget.Spacer(),
       ],
       size=BAR_HEIGHT,
       background=COLOR_PANEL_BACKGROUND,
    )


def top_bar():
    return bar.Bar([
            widget.GroupBox(
                borderwidth=1,
                active=COLOR_WS_ACTIVE,
                inactive=COLOR_WS_INACTIVE,
                this_current_screen_border=COLOR_CURRENT_SCREEN_BACKGROUND,
                this_screen_border=COLOR_OTHER_SCREEN_BACKGROUND,
                other_current_screen_border=COLOR_OTHER_SCREEN_BACKGROUND,
                other_screen_border=COLOR_OTHER_SCREEN_BACKGROUND,
                highlight_method="block",
                rounded=False,
            ),
            widget.Spacer(),
            widget_sep_primary(),
            widget.TextBox(
                text="\uf1eb",
                fontsize=24,
                background=COLOR_WIDGET_BACKGROUND_PRIMARY,
                foreground=COLOR_WIDGET_FOREGROUND_PRIMARY,
            ),
            widget_wifi(),
            widget_sep_secondary(),
            widget.TextBox(
                text="\ufa7d", 
                fontsize=24, 
                background=COLOR_WIDGET_BACKGROUND_SECONDARY, 
                foreground=COLOR_WIDGET_FOREGROUND_SECONDARY
            ),
            widget.Volume(
                background=COLOR_WIDGET_BACKGROUND_SECONDARY, 
                foreground=COLOR_WIDGET_FOREGROUND_SECONDARY
            ),
            widget_sep_primary(),
            widget.Clock(
                format="%I:%M %p",
                background=COLOR_WIDGET_BACKGROUND_PRIMARY,
                foreground=COLOR_WIDGET_FOREGROUND_PRIMARY
            ),
        ],
        size=BAR_HEIGHT,
        background=COLOR_PANEL_BACKGROUND,
    )


def widget_wifi():
    interface_name = None

    for iname in psutil.net_if_addrs().keys():
        if iname.startswith("wlp"):
            interface_name = iname
            break

    return widget.Net(
        interface=interface_name,
        format="{down} ↓↑ {up}",
        update_interval=5,
        background=COLOR_WIDGET_BACKGROUND_PRIMARY,
        foreground=COLOR_WIDGET_FOREGROUND_PRIMARY,
    )

def load_floating_layout():
    return layout.Floating(
        float_rules=[
            # Run the utility of `xprop` to see the wm class and name of an X client.
            # *layout.Floating.default_float_rules,
            Match(wm_type="dialog"),
            Match(wm_class="ranger-file-picker"),
        ]
    )

