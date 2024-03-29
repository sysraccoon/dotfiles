import logging

from dataclasses import dataclass, field
from typing import List, Callable, Any

from libqtile.config import Key, KeyChord, EzConfig
from libqtile.lazy import lazy

from screencast import set_screencast_mode, is_screencast_mode

from command_exec import rofi_execute_command

def load_commands(command_repo, workspaces, scratchpad_items):
    app_launcher = "rofi -show drun"
    window_selector = "rofi -show window"
    terminal = "kitty"
    app_lock = "xsecurelock"
    plover = "plover -s plover_send_command toggle"

    result_commands = []

    result_commands.extend(expand_commands([
        # command name          hotkeys                  action                                tags                   description
        ("toggle-workspace",     ["M-<period>"],          lazy.screen.toggle_group(),           ["navigation"],        "Toggle workspace"),
        ("next-screen",          ["M-<comma>"],           lazy.next_screen(),                   ["navigation"],        "Focus next screen"),

        ("focus-left-window",    ["M-h"],                 lazy.layout.left(),                   ["navigation"],        "Focus left window"),
        ("focus-right-window",   ["M-l"],                 lazy.layout.right(),                  ["navigation"],        "Focus right window"),
        ("focus-down-window",    ["M-j"],                 lazy.layout.down(),                   ["navigation"],        "Focus down window"),
        ("focus-up-window",      ["M-k"],                 lazy.layout.up(),                     ["navigation"],        "Focus up window"),

        ("focus-window-by-name", ["M-w M-<space>"],       lazy.spawn(window_selector),          ["navigation"],        "Focus window by name"),

        ("move-window-left",     ["M-S-h"],               lazy.layout.shuffle_left(),           ["manipulation"],      "Move window left"),
        ("move-window-right",    ["M-S-l"],               lazy.layout.shuffle_right(),          ["manipulation"],      "Move window right"),
        ("move-window-down",     ["M-S-j"],               lazy.layout.shuffle_down(),           ["manipulation"],      "Move window down"),
        ("move-window-up",       ["M-S-k"],               lazy.layout.shuffle_up(),             ["manipulation"],      "Move window up"),

        ("grow-window-down",     ["M-C-j"],               lazy.layout.grow_down(),              ["manipulation"],      "Grow window down"),
        ("grow-window-up",       ["M-C-k"],               lazy.layout.grow_up(),                ["manipulation"],      "Grow window up"),
        ("grow-window-left",     ["M-C-h"],               lazy.layout.grow_left(),              ["manipulation"],      "Grow window left"),
        ("grow-window-right",    ["M-C-l"],               lazy.layout.grow_right(),             ["manipulation"],      "Grow window right"),

        ("toggle-fullscreen",    ["M-S-f"],               lazy.window.toggle_fullscreen(),      ["manipulation"],      "Toggle fullscreen"),
        ("next-layout",          ["M-S-<space>"],         lazy.next_layout(),                   ["manipulation"],      "Switch to next layout"),
        ("kill-window",          ["M-S-c"],               lazy.window.kill(),                   ["manipulation"],      "Kill focused window"),

        ("toggle-floating",      ["M-f M-f"],             lazy.window.toggle_floating(),        ["manipulation"],      "Toggle floating"),
        ("float-cycle-forward",  ["M-f M-n"],             float_cycle_forward,                  ["manipulation"],      "Float window cycle forward"),
        ("float-cycle-backward", ["M-f M-p"],             float_cycle_backward,                 ["manipulation"],      "Float window cycle backward"),

        ("run-app-launcher",     ["M-<space>"],           lazy.spawn(app_launcher),             ["application"],       "Run application launcher (rofi)"),
        ("run-terminal",         ["M-<Return>"],          lazy.spawn(terminal),                 ["application"],       "Run terminal (alacritty)"),
        ("run-qtile-cmd",        ["M-<apostrophe>"],      rofi_execute_command(command_repo),   ["application"],       "Run qtile command"),
        ("make-screenshot",      ["<Print>"],             lazy.spawn("flameshot gui"),          ["application"],       "Make screenshot (flameshot)"),

        ("reload-config",        ["M-s M-r"],             lazy.reload_config(),                 ["system"],            "Reload qtile config"),
        ("shutdown-qtile",       ["M-s M-S-q"],           lazy.shutdown(),                      ["system"],            "Shutdown qtile"),
        ("shutdown-system",      ["M-s M-S-s"],           lazy.spawn("shutdown now"),           ["system"],            "Shutdown system"),
        ("reboot-system",        ["M-s M-S-r"],           lazy.spawn("reboot"),                 ["system"],            "Reboot system"),
        ("lock-system",          ["M-s M-l"],             lazy.spawn(app_lock),                 ["system"],            "Lock system"),

        ("show-key-name",        ["M-t M-k"],             lazy.spawn("show-key-name"),          ["tools"],             "Display next pressed key name"),
        ("translate-text",       ["M-t M-t"],             lazy.spawn("trans-rofi"),             ["tools"],             "Translate text"),
        ("clip-password",        ["M-t M-p"],             lazy.spawn("pass-rofi"),              ["tools"],             "Get and save password to clipboard"),
        ("open-cheatsheet",      ["M-t M-c"],             lazy.spawn("cheatsheet-rofi"),        ["tools"],             "Open cheatsheet"),
        ("open-email",           ["M-t M-m"],             lazy.spawn("ext-tui neomutt"),        ["tools"],             "Open local mail client"),
 
        ("toggle-plover",        ["M-p"],                 lazy.spawn(plover),                   ["tools"],             "Toggle plover (steno mode)"),
        ("toggle-screencast",    ["M-t M-s"],             toggle_screencast_mode,               ["tools"],             "Toggle screencast mode"),

        ("manual-nixos-options",   ["M-S-<slash> M-S-o"],           lazy.spawn("xdg-open 'https://search.nixos.org/options?channel=unstable'"), ["help"], "Open nixos search options site"),
        ("manual-nixos-packages",  ["M-S-<slash> M-S-p"],           lazy.spawn("xdg-open 'https://search.nixos.org/packages?channel=unstable'"), ["help"], "Open nixos search packages site"),
    ]))

    # custom keyboard layout
    result_commands.extend(expand_commands([
        ("type-left-bracket",   ["M-e M-h"],   lazy.spawn("xvkbd -xsendevent -text '['"),["tools", "keyboard"], "Type left bracket"),
        ("type-right-bracket",  ["M-e M-l"],   lazy.spawn("xvkbd -xsendevent -text ']'"),["tools", "keyboard"],"Type right bracket"),
        ("type-left-brace",   ["M-C-e M-C-h"],   lazy.spawn("xvkbd -xsendevent -text '{'"),["tools", "keyboard"], "Type left bracket"),
        ("type-right-brace",  ["M-C-e M-C-l"],   lazy.spawn("xvkbd -xsendevent -text '}'"),["tools", "keyboard"],"Type right bracket"),
    ]))

    result_commands.extend(expand_commands([
        ("set-en-layout", ["M-<bracketleft>"], lazy.spawn("xkb-switch -s 'us(dvorak)'"), ["system"], "Set english dvorak as active layout"),
        ("set-ru-layout", ["M-<bracketright>"], lazy.spawn("xkb-switch -s 'ru'"), ["system"], "Set russian as active layout"),

        ("lower-audio-volume", ["<XF86AudioLowerVolume>", "M-a M-j"], lazy.spawn("amixer -q sset Master 10%-"), ["system"], "Lower audio volume"),
        ("raise-audio-volume", ["<XF86AudioRaiseVolume>", "M-a M-k"], lazy.spawn("amixer -q sset Master 10%+"), ["system"], "Raise audio volume"),
        ("mute-audio", ["<XF86AudioMute>", "M-a M-m"], lazy.spawn("amixer set Master 1+ toggle"), ["system"], "Mute/Unmute audio"),
    ]))

    for audio_index in range(10):
        result_commands.append(CommandInfo(
            name=f"set-default-audio-{audio_index}",
            hotkeys=[f"M-a M-{audio_index}"],
            action=lazy.spawn(f"sh -c \"set-default-audio '{audio_index}'\""),
            tags=["audio"],
            desc=f"Set audio device with index {audio_index} as default",
        ))

    workspace_shortcut_keys = [str(i) for i in range(10)]

    for ws in workspaces:
        focus_hotkeys = [f"M-g M-{key}" for key in ws.navigation_keys]
        move_hotkeys = [f"M-m M-{key}" for key in ws.navigation_keys]

        focus_hotkeys.extend([f"M-{key}" for key in ws.navigation_keys if key in workspace_shortcut_keys])
        move_hotkeys.extend([f"M-S-{key}" for key in ws.navigation_keys if key in workspace_shortcut_keys])

        focus_action = focus_workspace_action(ws)
        
        result_commands.extend([
            CommandInfo(
                name=f"focus-{ws.name}-ws", 
                hotkeys=focus_hotkeys,
                action=focus_action,
                tags=["navigation"], 
                desc=f"Focus {ws.name} workspace",
            ),
            CommandInfo(
                name=f"move-window-to-{ws.name}-ws",
                hotkeys=move_hotkeys,
                action=lazy.window.togroup(ws.name),
                tags=["manipulation"],
                desc=f"Move current window to {ws.name} workspace",
            ),
        ])

    for scratch_item in scratchpad_items:
        result_commands.append(CommandInfo(
            name=f"toggle-{scratch_item.name}-scratch",
            hotkeys=scratch_item.hotkeys,
            action=lazy.group["scratchpad"].dropdown_toggle(scratch_item.name),
            tags=["scratchpad"],
            desc=f"Toggle {scratch_item.name} scratch item",
        ))

    return result_commands


floating_window_index = 0

def float_cycle(qtile, forward: bool):
    global floating_window_index
    floating_windows = []
    for window in qtile.current_group.windows:
        if window.floating:
            floating_windows.append(window)
    if not floating_windows:
        return
    floating_window_index = min(floating_window_index, len(floating_windows) -1)
    if forward:
        floating_window_index += 1
    else:
        floating_window_index += 1
    if floating_window_index >= len(floating_windows):
        floating_window_index = 0
    if floating_window_index < 0:
        floating_window_index = len(floating_windows) - 1
    win = floating_windows[floating_window_index]
    win.cmd_bring_to_front()
    win.cmd_focus()

@lazy.function
def float_cycle_backward(qtile):
    float_cycle(qtile, False)

@lazy.function
def float_cycle_forward(qtile):
    float_cycle(qtile, True)


@lazy.function
def toggle_screencast_mode(qtile):
    set_screencast_mode(not is_screencast_mode())
    qtile.cmd_reload_config()


def focus_workspace_action(workspace):
    if not workspace.on_enter_callbacks:
        return lazy.group[workspace.name].toscreen()

    @lazy.function
    def _inner(qtile):
        target_grp = next(grp for grp in qtile.groups if grp.name == workspace.name)
        target_grp.cmd_toscreen(qtile.screens.index(qtile.current_screen))

        for callback in workspace.on_enter_callbacks:
            callback(qtile, workspace)

    return _inner


@dataclass
class CommandInfo:
    name: str
    action: Any
    desc: str = ""
    tags: List[str] = field(default_factory=list)
    hotkeys: List[str] = field(default_factory=list)
    hidden: bool = False

    def add_key(self, key: str):
        self.hotkeys.append(key)

    def add_tag(self, tag: str):
        self.tags.append(tag)


@dataclass
class CommandRepository:
    commands: List[CommandInfo] = field(default_factory=list)
    combo_parser: EzConfig = field(default_factory=EzConfig)

    def build_hotkeys(self):
        key_tree = self._build_key_tree()
        builded_hotkeys = self._build_qtile_keys(key_tree)
        return builded_hotkeys

    def append(self, command: CommandInfo):
        self.commands.append(command)

    def extend(self, commands: List[CommandInfo]):
        self.commands.extend(commands)

    def get_by_name(self, name: str):
        for cmd in self.commands:
            if cmd.name == name:
                return cmd

        logging.warning(f"CommandRepository.get_by_name name: {name} missed")
        return None

    def _build_key_tree(self):
        commands = self.commands

        key_tree = {}
        for cmd in commands:
            if len(cmd.hotkeys) == 0:
                continue

            for hotkey in cmd.hotkeys:
                splitted = hotkey.split(" ")
                combo = splitted[-1]
                chords = splitted[:-1]

                pos_in_tree = key_tree

                for chord in chords:
                    if chord not in key_tree:
                        key_tree[chord] = {}
                    pos_in_tree = key_tree[chord]

                if not isinstance(pos_in_tree, dict):
                    logging.warning(f"Fail while bind hotkey for {cmd.name}. Reason: other command ({pos_in_tree.name}) already binded. Skip")
                    continue

                if combo in pos_in_tree:
                    logging.warning(f"Fail while bind hotkey for {cmd.name}. Reason: other key chord already binded. Skip")
                    continue

                pos_in_tree[combo] = cmd

        return key_tree


    def _build_qtile_keys(self, tree):
        results = []

        for combo, cmd in tree.items():
            mods, key = self.combo_parser.parse(combo)

            if isinstance(cmd, CommandInfo):
                hotkey = Key(mods, key, cmd.action, desc=cmd.desc)
                results.append(hotkey)
            elif isinstance(cmd, dict):
                sub_hotkeys = self._build_qtile_keys(cmd)
                key_chord = KeyChord(mods, key, sub_hotkeys)
                results.append(key_chord)
            else:
                logging.error(f"Unrecognized command type: {cmd}. Expected dict or CommandInfo")

        return results


def expand_commands(cmd_tuples):
    return [
        CommandInfo(name=name, hotkeys=hotkeys, action=action, tags=tags, desc=desc)
        for name, hotkeys, action, tags, desc in cmd_tuples
    ]


def bind_hotkey_with_command(command_repo, name, key):
    command = command_repo.get_by_name(name)
    command.add_key(key)


def bind_hotkeys_with_commands(command_repo, name_key_pairs):
    for name, key in name_key_pairs:
        bind_hotkey_with_command(command_repo, name, key)

