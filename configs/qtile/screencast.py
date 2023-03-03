import os
import subprocess
import psutil
from libqtile import hook

KITTY_SCREENCAST_FONT_SIZE = 20
KITTY_DEFAULT_FONT_SIZE = 11

def set_screencast_mode(enabled: bool):
    os.environ["SCREENCAST_MODE"] = "1" if enabled else "0"


def is_screencast_mode():
    return os.getenv("SCREENCAST_MODE") == "1"


@hook.subscribe.startup
def screencast_tweaks():
    if is_screencast_mode():
        kitty_font = str(KITTY_SCREENCAST_FONT_SIZE)
    else:
        kitty_font = str(KITTY_DEFAULT_FONT_SIZE)

    subprocess.Popen(["kitty-global-set-font", kitty_font])
    # subprocess.Popen(["kitty-global-command", "env", f"SCREENCAST_MODE={os.getenv('SCREENCAST_MODE') or '0'}"])


@hook.subscribe.client_managed
def screencast_on_new_window(client):
    if not is_screencast_mode():
        return

    if client.name.startswith("kitty"):
        pid = client.window.get_net_wm_pid()
        subprocess.Popen(["kitty-local-set-font", str(pid), str(KITTY_SCREENCAST_FONT_SIZE)])

