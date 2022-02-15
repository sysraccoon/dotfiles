import os
import subprocess

from typing import List

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

COLOR_WIDGET_FONT = "#eceff4"
COLOR_WS_ACTIVE = "#eceff4"
COLOR_WS_INACTIVE = "#d8dee9"
COLOR_PANEL_BACKGROUND = "#2e3440"
COLOR_CURRENT_SCREEN_BACKGROUND = "#4c566a"
COLOR_OTHER_SCREEN_BACKGROUND = "#3b4252"
COLOR_BORDER_FOCUS = "#4c566a"
COLOR_BORDER_NORMAL = "#3b4252"
COLOR_WIDGET_BACKGROUND_PRIMARY = "#434758"
COLOR_WIDGET_FOREGROUND_PRIMARY = "#e5e9f0"
COLOR_WIDGET_BACKGROUND_SECONDARY = "#2e3440"
COLOR_WIDGET_FOREGROUND_SECONDARY = "#e5e9f0"

mod = "mod4"
shift = "shift"

terminal = "alacritty"

keys = [

    Key([mod, shift], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key( [mod, "shift"], "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    Key([mod], "comma", lazy.next_screen()),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    Key([mod], "Tab", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, shift], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "space", lazy.spawn("rofi -show drun"), desc="Launch rofi"),
    Key([mod], "w", lazy.screen.toggle_group()),
    Key([mod], "f", lazy.window.toggle_fullscreen()),
]


def window_navigation():
    left_key = "h"
    right_key = "l"
    down_key = "j"
    up_key = "k"

    return [
        Key([mod], left_key, lazy.layout.left(), desc="Move focus to left"),
        Key([mod], right_key, lazy.layout.right(), desc="Move focus to right"),
        Key([mod], down_key, lazy.layout.down(), desc="Move focus down"),
        Key([mod], up_key, lazy.layout.up(), desc="Move focus up"),

        Key([mod, shift], left_key, lazy.layout.shuffle_left(), desc="Move window to the left"),
        Key([mod, shift], right_key, lazy.layout.shuffle_right(), desc="Move window to the right"),
        Key([mod, shift], down_key, lazy.layout.shuffle_down(), desc="Move window down"),
        Key([mod, shift], up_key, lazy.layout.shuffle_up(), desc="Move window up"),
    ]

groups_meta = [
    (4, "sys"),
    (5, "dev"),
    (6, "www"),
    (7, "msg"),
    (8, "rec"),
    (9, "game"),
]

groups = []

for group_id, group_name in groups_meta:
    groups.append(Group(group_name))

def workspace_navigation():
    keys = []
    for _, group_name in groups_meta:
        keys.append(Key([mod], group_name[0], lazy.group[group_name].toscreen()))
        keys.append(Key([], group_name[0], lazy.group[group_name].toscreen()))
    return keys

def workspace_window_manipulation():
    keys = []
    for _, group_name in groups_meta:
        keys.append(Key([mod], group_name[0], lazy.window.togroup(group_name)))
        keys.append(Key([], group_name[0], lazy.window.togroup(group_name)))
    return keys

keys.extend(window_navigation())
keys.append(KeyChord([mod], "g", workspace_navigation()))
keys.append(KeyChord([mod], "m", workspace_window_manipulation()))

layouts = [
    layout.Columns(border_focus=COLOR_BORDER_FOCUS, border_normal=COLOR_BORDER_NORMAL, border_width=2),
    layout.Max(),
]

widget_defaults = dict(
    font="ubuntu",
    fontsize=13,
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
cursor_warp = False
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
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = False

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.Popen([home + "/.config/qtile/autostart"])
