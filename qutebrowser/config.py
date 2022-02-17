config.load_autoconfig(True)

config.source("pregenerated.py")
config.source("nord.py")

c.hints.chars = "aoeuhtnspg.c"
c.hints.min_chars = 1
c.url.start_pages = ["https://duckduckgo.com"]
c.aliases = {
    "x": "quit --save",
}

c.fileselect.handler = "external"
c.fileselect.single_file.command = ["alacritty", "--class", "ranger-file-picker,ranger", "-e", "ranger", "--choosefile", "{}"]
c.fileselect.multiple_files.command = ["alacritty", "--class", "ranger-file-picker,ranger", "-e", "ranger", "--choosefiles", "{}"]

c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "re": "https://www.reddit.com/r/{}",
    "hb": "https://habr.com/en/search/?q={}&target_type=posts",
    "yt": "https://www.youtube.com/results?search_query={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "g": "https://www.google.com/search?q={}",
    "aw": "https://wiki.archlinux.org/?search={}",
}

for key in "duJK":
    config.unbind(key)

config.bind("d", "scroll-page 0 0.5")
config.bind("u", "scroll-page 0 -0.5")
config.bind("U", "undo")
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("<", "tab-move -")
config.bind(">", "tab-move +")
config.bind("<Shift-Escape>", "fake-key <Escape>")

