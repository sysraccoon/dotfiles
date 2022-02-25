# Qtile modules
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

import importlib

# Force reload all custom modules
import theme; importlib.reload(theme)
import commands; importlib.reload(commands)

# Import from custom modules
from theme import *
from commands import CommandRepository, load_commands


def load_group_names():
    return [ "sys", "dev", "www", "msg", "rec", "vid", "game" ]


def load_groups(group_names):
    groups = []
    for group_name in group_names:
        matches = []
        if group_name == "www":
            matches = [Match(wm_class=["qutebrowser"])]
        elif group_name == "msg":
            matches = [
                Match(wm_class=["telegram-desktop"]),
                Match(wm_class=["discord"])
            ]
        elif group_name == "vid":
            matches = [Match(wm_class=["mpv"])]
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
        Screen(top=top_bar()),
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
        layout.Columns(border_focus=COLOR_BORDER_FOCUS, border_normal=COLOR_BORDER_NORMAL, border_width=2),
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
            widget.Net(
                interface="wlp5s0",
                format="{down} ↓↑ {up}",
                update_interval=5,
                background=COLOR_WIDGET_BACKGROUND_PRIMARY,
                foreground=COLOR_WIDGET_FOREGROUND_PRIMARY,
            ),
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
        24,
        # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
        # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        background=COLOR_PANEL_BACKGROUND,
    )


def load_floating_layout():
    return layout.Floating(
        float_rules=[
            # Run the utility of `xprop` to see the wm class and name of an X client.
            # *layout.Floating.default_float_rules,
            Match(wm_class="confirmreset"),  # gitk
            Match(wm_class="makebranch"),  # gitk
            Match(wm_class="maketag"),  # gitk
            Match(wm_class="ssh-askpass"),  # ssh-askpass
            Match(title="branchdialog"),  # gitk
            Match(title="pinentry"),  # GPG key password entry

            Match(wm_class="ranger-file-picker"),
        ]
    )

