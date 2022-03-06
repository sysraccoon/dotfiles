import logging

from dataclasses import dataclass, field
from typing import List, Callable, Any

from libqtile.config import Key, KeyChord, EzConfig
from libqtile.lazy import lazy

from command_exec import rofi_execute_command

def load_commands(command_repo, group_names):
    app_launcher = "rofi -show drun"
    terminal = "alacritty"

    result_commands = []

    result_commands.extend(expand_commands([
        # command name          hotkeys                  action                                tags                   description
        ("toggle-workspace",    ["M-<period>"],          lazy.screen.toggle_group(),           ["navigation"],        "Toggle workspace"),
        ("next-screen",         ["M-<comma>"],           lazy.next_screen(),                   ["navigation"],        "Focus next screen"),

        ("focus-left-window",   ["M-h"],                 lazy.layout.left(),                   ["navigation"],        "Focus left window"),
        ("focus-right-window",  ["M-l"],                 lazy.layout.right(),                  ["navigation"],        "Focus right window"),
        ("focus-down-window",   ["M-j"],                 lazy.layout.down(),                   ["navigation"],        "Focus down window"),
        ("focus-up-window",     ["M-k"],                 lazy.layout.up(),                     ["navigation"],        "Focus up window"),

        ("move-window-left",    ["M-S-h"],               lazy.layout.shuffle_left(),           ["manipulation"],      "Move window left"),
        ("move-window-right",   ["M-S-l"],               lazy.layout.shuffle_right(),          ["manipulation"],      "Move window right"),
        ("move-window-down",    ["M-S-j"],               lazy.layout.shuffle_down(),           ["manipulation"],      "Move window down"),
        ("move-window-up",      ["M-S-k"],               lazy.layout.shuffle_up(),             ["manipulation"],      "Move window up"),

        ("toggle-fullscreen",   ["M-f"],                 lazy.window.toggle_fullscreen(),      ["manipulation"],      "Toggle fullscreen"),
        ("toggle-floating",     ["M-S-f"],               lazy.window.toggle_floating(),        ["manipulation"],      "Toggle floating"),
        ("kill-window",         ["M-<Tab>"],             lazy.window.kill(),                   ["manipulation"],      "Kill focused window"),

        ("run-app-launcher",    ["M-<space>"],           lazy.spawn(app_launcher),             ["application"],       "Run application launcher (rofi)"),
        ("run-terminal",        ["M-<Return>"],          lazy.spawn(terminal),                 ["application"],       "Run terminal (alacritty)"),
        ("run-qtile-cmd",       ["M-<apostrophe>"],      rofi_execute_command(command_repo),   ["application"],       "Run qtile command"),
        ("make-screenshot",     ["<Print>"],             lazy.spawn("flameshot gui"),          ["application"],       "Make screenshot (flameshot)"),

        ("reload-config",       ["M-<minus> M-r"],       lazy.reload_config(),                 ["system"],            "Reload qtile config"),
        ("shutdown-qtile",      ["M-<minus> M-q"],       lazy.shutdown(),                      ["system"],            "Shutdown qtile"),
        ("shutdown-system",     ["M-<minus> M-s"],       lazy.spawn("shutdown now"),           ["system"],            "Shutdown system"),

        ("show-key-name",       ["M-t M-k"],             lazy.spawn("show-key-name"),          ["tools"],             "Display next pressed key name"),
    ]))

    result_commands.extend(expand_commands([
        ("set-en-layout", ["M-<bracketleft>"], lazy.spawn("xkb-switch -s 'us(dvorak)'"), ["system"], "Set english dvorak as active layout"),
        ("set-ru-layout", ["M-<bracketright>"], lazy.spawn("xkb-switch -s 'ru'"), ["system"], "Set russian as active layout"),
    ]))

    for audio_index in range(10):
        result_commands.append(CommandInfo(
            name=f"set-default-audio-{audio_index}",
            hotkeys=[f"M-a M-{audio_index}"],
            action=lazy.spawn(f"sh -c \"set-default-audio '{audio_index}'\""),
            tags=["audio"],
            desc=f"Set audio device with index {audio_index} as default",
        ))

    for group_name in group_names:
        result_commands.extend([
            CommandInfo(
                name=f"focus-{group_name}-ws", 
                hotkeys=[f"M-g M-{group_name[0]}"],
                action=lazy.group[group_name].toscreen(), 
                tags=["navigation"], 
                desc=f"Focus {group_name} workspace",
            ),
            CommandInfo(
                name=f"move-window-to-{group_name}-ws",
                hotkeys=[f"M-m M-{group_name[0]}"],
                action=lazy.window.togroup(group_name),
                tags=["manipulation"],
                desc=f"Move current window to {group_name} workspace",
            ),
        ])

    return result_commands


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

