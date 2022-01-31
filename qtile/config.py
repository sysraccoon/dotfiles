from typing import List

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

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
]


def window_navigation():
    left_key = "h"
    right_key = "l"
    down_key = "j"
    up_key = "k"

    bind = lambda key, dir: Key([mod], key, dir)

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
    (8, "obs"),
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

keys.extend(window_navigation())
keys.append(KeyChord([mod], "g", workspace_navigation()))



layouts = [
    layout.Columns(border_focus="#458588", border_width=2),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="ubuntu",
    fontsize=13,
    padding=3,
    foreground="#bdae93",
)
extension_defaults = widget_defaults.copy()


def top_bar():
    return bar.Bar([
            widget.GroupBox(
                borderwidth=1,
                active="#fbf1c7",
                inactive="#a89984",
                this_current_screen_border="#458588",
                highlight_method="block",
                rounded=False,
            ),
            widget.Spacer(),
            widget.TextBox(text="Battery"),
            widget.Battery(),
            widget.Sep(),
            widget.Clock(format="%I:%M %p"),
        ],
        24,
        # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
        # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        background="#282828",
    )

screens = [
    Screen( top=top_bar(),),
    Screen( top=top_bar(),),
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
