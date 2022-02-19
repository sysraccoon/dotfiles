import logging
import subprocess

from libqtile.command import lazy

def available_commands(all_commands):
  ignored_command_names = [ ]
  return [command for command in all_commands if command.name not in ignored_command_names]


def prepare_for_format(commands):
    result = []

    for command in commands:
        name = command.name
        hotkeys = ",".join(command.hotkeys)
        tags = " ".join(["#" + tag for tag in command.tags])
        desc = command.desc
        result.append((hotkeys, name, desc, tags))

    result.sort(key=lambda x: x[2], reverse=True)

    result.insert(0, ("key", "name", "desc", "tags"))
    return result

def rofi_format(commands):
    result = []

    prepared = prepare_for_format(commands)
    
    col_count = len(prepared[0])
    col_sizes = [1 for _ in range(col_count)]
    for row in prepared:
        for col_id in range(col_count):
            col_size = len(row[col_id])
            if col_size > col_sizes[col_id]:
                col_sizes[col_id] = col_size

    format_template = " | ".join([
        "{:<" + str(col_size) + "s}" for col_size in col_sizes
    ])

    for row in prepared:
        result.append(format_template.format(*row))

    title = result[0]
    del result[0]

    return title, "\n".join(result)

@lazy.function
def rofi_execute_command(qtile, command_repo):

    commands = available_commands(command_repo.commands)
    title, input_values = rofi_format(commands)

    rofi_command = ["rofi", "-dmenu", "-p", "qtile", "-mesg", title]

    input_binary = input_values.encode(encoding='UTF-8', errors='strict')

    rofi = subprocess.run(rofi_command, input=input_binary, capture_output=True)
