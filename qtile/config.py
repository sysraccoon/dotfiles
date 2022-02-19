import os
import subprocess
import logging

from typing import List

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

from theme import *

from commands import CommandRepository, load_commands

logging.basicConfig(level=logging.DEBUG)

group_names = [ "sys", "dev", "www", "msg", "rec", "game" ]
groups = []

for group_name in group_names:
    groups.append(Group(group_name))

command_repo = CommandRepository()
commands = load_commands(command_repo, group_names)
command_repo.extend(commands)

keys = command_repo.build_hotkeys()

layouts = [
    layout.Columns(border_focus=COLOR_BORDER_FOCUS, border_normal=COLOR_BORDER_NORMAL, border_width=2),
    layout.Max(),
]

widget_defaults = dict(
    font=FONT_NAME,
    fontsize=FONT_SIZE,
    padding=3,
    foreground=COLOR_WIDGET_FONT,
)
extension_defaults = widget_defaults.copy()

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

screens = [
    Screen(top=top_bar()),
    Screen(top=top_bar()),
]


mod = "mod4"
# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = False
bring_front_click = False
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry

        Match(wm_class="ranger-file-picker"),
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = False

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.Popen([home + "/.config/qtile/autostart"])
