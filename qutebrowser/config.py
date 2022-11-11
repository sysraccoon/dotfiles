config.load_autoconfig(True)

config.source("pregenerated.py")
config.source("nord.py")

c.content.autoplay = False

c.hints.chars = "aoeuhtnspg.c"
c.hints.min_chars = 1
c.url.start_pages = ["https://www.google.com"]
c.aliases = {
    "x": "quit --save",
}

c.fileselect.handler = "external"
c.fileselect.single_file.command = [
    "alacritty",
    "--class", "ranger-file-picker,ranger",
    "-e", "ranger",
    "--choosefile", "{}",
]

c.fileselect.multiple_files.command = [
    "alacritty",
    "--class", "ranger-file-picker,ranger",
    "-e", "ranger",
    "--choosefiles", "{}",
]

c.editor.command = ["alacritty", "-e", "nvim", "{}"]

c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "re": "https://www.reddit.com/r/{}",
    "hb": "https://habr.com/en/search/?q={}&target_type=posts",
    "yt": "https://www.youtube.com/results?search_query={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "g": "https://www.google.com/search?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
}

unbinded_keybindings = [
    "d",
    "u",
    "J",
    "K",
    "M",
    "<Control-w>",
    "gf",
]

for binding in unbinded_keybindings:
    config.unbind(binding)

keybindings = {
    "d": "scroll-page 0 0.5",
    "u": "scroll-page 0 -0.5",
    "<Control-d>": "fake-key <PgDown>",
    "<Control-u>": "fake-key <PgUp>",
    "U": "undo",
    "J": "tab-prev",
    "K": "tab-next",
    "<": "tab-move -",
    ">": "tab-move +",
    "<Shift-Escape>": "fake-key <Escape>",
    "xb": "config-cycle statusbar.show always never",
    "xt": "config-cycle tabs.show always never",
    "xm": "hint links spawn mpv {hint-url}",
    "xM": "spawn mpv {url}",
    "<Control-r>": "config-source",
    "ce": "config-edit",
    "yg": "spawn --userscript yank-github-url",
    "gf": "open g {url:host}",
    "<Control-w>": ("fake-key <Control-BackSpace>", {"mode": "insert"}),
    "<Control-h>": ("fake-key <BackSpace>", {"mode": "insert"}),
    "<Control-b>": ("fake-key <Control-Left>", {"mode": "insert"}),
    "<Control-f>": ("fake-key <Control-Right>", {"mode": "insert"}),
    "<Alt-b>": ("fake-key <Left>", {"mode": "insert"}),
    "<Alt-f>": ("fake-key <Right>", {"mode": "insert"}),
    "<Control-a>": ("fake-key <Home>", {"mode": "insert"}),
    "<Control-e>": ("fake-key <End>", {"mode": "insert"}),
}

for keystroke, binding_params in keybindings.items():
    action = None
    params = {}
    if isinstance(binding_params, str):
        action = binding_params
    elif isinstance(binding_params, tuple):
        action = binding_params[0]
        params = binding_params[1]
    else:
        raise NotImplementedError()

    config.bind(keystroke, action, **params)

