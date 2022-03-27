# Python modules
import os
import subprocess
import logging
import importlib

from typing import List
from libqtile import hook

import settings; importlib.reload(settings)

from settings import load_group_names, load_groups, load_keys, load_mouse, load_layouts, \
                     load_widget_defaults, load_extension_defaults, load_floating_layout, \
                     load_screens


def initialize_config(c):
    group_names = load_group_names()
    c.groups = load_groups(group_names)
    c.keys = load_keys(group_names)
    c.mouse = load_mouse()
    c.layouts = load_layouts()

    c.widget_defaults = load_widget_defaults()
    c.extension_defaults = load_extension_defaults()
    c.screens = load_screens()

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


logging.basicConfig(level=logging.DEBUG)

import config
initialize_config(config)
