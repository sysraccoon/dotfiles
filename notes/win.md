# Windows imperative configuration

## Table of Contents {ToC}

<!-- toc-start -->

- [Keyboard](<#Keyboard>)
  - [Configure kanata](<#Configure kanata>)
  - [Configure RU layout with dvorak virtual codes](<#Configure RU layout with dvorak virtual codes>)
- [Firefox](<#Firefox>)
  - [Setup userChrome.css](<#Setup userChrome.css>)

<!-- toc-end -->

## Keyboard

See more general information about keyboard configuration in [keyboard article](./keyboard.md)

### Configure kanata

1. Download latest windows kanata build from [release page](https://github.com/jtroo/kanata/releases)
2. Place it somewhere and add to `PATH` variable.
3. Add script to autostart by using `dotfiles\modules\combined\keyboard\kanata\autostart-kanata.ps1` (edit path to kanata.exe if need)

### Configure RU layout with dvorak virtual codes

1. Open `Keyboard Layout Creator` and select `File > Load Source File`
2. Select `dotfiles\modules\combined\keyboard\dvorak\ru-dvorak-vk.klc`
3. Open `Project > Build DLL and Setup package`

## Firefox

### Setup userChrome.css

1. Open `about:support`, find `Profile Folder` and click `Open Folder`
2. Create directory named `chrome`
3. Create symlink to `userChrome.css` in dotfiles:
```powershell
gsudo New-Item -Path userChrome.css -ItemType SymbolicLink -Value D:\dotfiles\modules\home\browsers\firefox\userChrome.css
```
4. Open `about:config` and set `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`
5. Restart firefox

