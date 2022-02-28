config.load_autoconfig(True)

config.source("pregenerated.py")
config.source("nord.py")

c.hints.chars = "aoeuhtnspg.c"
c.hints.min_chars = 1
c.url.start_pages = ["https://www.google.com"]
c.aliases = {
    "x": "quit --save",
}

c.fileselect.handler = "external"
c.fileselect.single_file.command = ["alacritty", "--class", "ranger-file-picker,ranger", "-e", "ranger", "--choosefile", "{}"]
c.fileselect.multiple_files.command = ["alacritty", "--class", "ranger-file-picker,ranger", "-e", "ranger", "--choosefiles", "{}"]

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

for key in "duJKM":
    config.unbind(key)
config.unbind("<Control-w>")

config.bind("d", "scroll-page 0 0.5")
config.bind("u", "scroll-page 0 -0.5")
config.bind("U", "undo")
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("<", "tab-move -")
config.bind(">", "tab-move +")
config.bind("<Shift-Escape>", "fake-key <Escape>")
config.bind("xb", "config-cycle statusbar.show always never")
config.bind("xt", "config-cycle tabs.show always never")
config.bind("xm", "hint links spawn mpv {hint-url}")
config.bind("xM", "spawn mpv {url}")
config.bind("cs", "config-source")
config.bind("ce", "config-edit")

config.bind("<Control-w>", "fake-key <Control-BackSpace>", mode="insert")
config.bind("<Control-h>", "fake-key <BackSpace>", mode="insert")
config.bind("<Control-b>", "fake-key <Control-Left>", mode="insert")
config.bind("<Control-f>", "fake-key <Control-Right>", mode="insert")
config.bind("<Alt-b>", "fake-key <Left>", mode="insert")
config.bind("<Alt-f>", "fake-key <Right>", mode="insert")
config.bind("<Control-a>", "fake-key <Home>", mode="insert")
config.bind("<Control-e>", "fake-key <End>", mode="insert")

