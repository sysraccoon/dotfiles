# Python modules
import os
import subprocess
import logging
import importlib

from typing import List
from libqtile import hook

import settings; importlib.reload(settings)

from settings import load_workspaces, load_scratchpad, load_scratchpad_items, load_groups, \
                     load_keys, load_mouse, load_layouts,  load_widget_defaults, \
                     load_extension_defaults, load_floating_layout, \
                     load_screens


def initialize_config(c):
    workspaces = load_workspaces()
    scratchpad_items = load_scratchpad_items()
    c.groups = load_groups(workspaces)
    c.groups.append(load_scratchpad(scratchpad_items))
    c.keys = load_keys(workspaces, scratchpad_items)
    c.mouse = load_mouse()
    c.layouts = load_layouts()

    c.widget_defaults = load_widget_defaults()
    c.extension_defaults = load_extension_defaults()
    c.fake_screens = load_screens()

    c.floating_layout = load_floating_layout()
    c.dgroups_key_binder = None
    c.dgroups_app_rules = []  # type: List
    c.follow_mouse_focus = False
    c.bring_front_click = False
    c.cursor_warp = True
    c.auto_fullscreen = True
    c.focus_on_window_activation = "smart"
    c.reconfigure_screens = False
    c.auto_minimize = True


@hook.subscribe.startup_once
def autostart():
    # home = os.path.expanduser("~")
    # subprocess.Popen([home + "/.config/qtile/autostart"])
    pass

@hook.subscribe.client_focus
def float_always_bring_to_front(_):
    from libqtile import qtile
    for window in qtile.current_group.windows:
        if window.floating:
            window.cmd_bring_to_front()

logging.basicConfig(level=logging.DEBUG)

import config
initialize_config(config)
