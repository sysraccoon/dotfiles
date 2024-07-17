# ZSH configuration

## Table of Contents {TOC}

<!-- toc-start -->

- [Nix home-manager module](<#Nix home-manager module>)
- [.zshrc](<#.zshrc>)
  - [Handle non Interactive](<#Handle non Interactive>)
  - [Home Manager](<#Home Manager>)
  - [Plugins](<#Plugins>)
  - [General](<#General>)
  - [Prompt {starship}](<#Prompt {starship}>)
  - [Fuzzy Finder {fzf}](<#Fuzzy Finder {fzf}>)
    - [Fuzzy Auto Completion {fzf-tab}](<#Fuzzy Auto Completion {fzf-tab}>)
  - [Editor {neovim}](<#Editor {neovim}>)
  - [Keybindings](<#Keybindings>)
  - [Folder Specific Environment {direnv}](<#Folder Specific Environment {direnv}>)
  - [Syntax Highlighting {zsh-syntax-highlighitng}](<#Syntax Highlighting {zsh-syntax-highlighitng}>)
  - [Aliases](<#Aliases>)
    - [GNU utils replacement](<#GNU utils replacement>)
    - [Git aliases](<#Git aliases>)
    - [Nix Aliases](<#Nix Aliases>)
    - [Network Aliases](<#Network Aliases>)
    - [Archive Aliases](<#Archive Aliases>)
    - [ADB Aliases](<#ADB Aliases>)
    - [Misc Aliases](<#Misc Aliases>)

<!-- toc-end -->

## Nix home-manager module

My custom module create symlinks to zshrc and starship configuration. Also it install all related
packages.

```nix {.nix file=modules/home/shells/zsh/zsh.nix}
{
  config,
  pkgs,
  lib,
  impurity,
  ...
}: let
  cfg = config.sys.home.shells.zsh;
in {
  options.sys.home.shells.zsh = {
    enable = lib.mkEnableOption "toggle custom zsh setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh
      <<zsh-packages>>
    ];

    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/bin"
    ];

    xdg.enable = true;
    xdg.configFile."starship/starship.toml".source = impurity.link ./starship.toml;
    xdg.configFile."zsh".source = impurity.link ./zsh;
    home.file.".zshrc".source = pkgs.writeText ".zshrc" ''
      source "${config.xdg.configHome}/zsh/config.zsh"
    '';
  };
}
```

## .zshrc

This section produce [config.zsh](../modules/home/shells/zsh/zsh/config.zsh)

```bash {.bash file=modules/home/shells/zsh/zsh/config.zsh}
<<zshrc-body>>
```

### Handle non Interactive

If not running interactively, don't do anything.

```bash {.bash #zshrc-body}
[[ $- != *i* ]] && {
  >&2 echo "interactive mode didn't support"
  exit 1;
}
```

### Home Manager

This adapt shell environment for home-manager stuff.

```bash {.bash #zshrc-body}
if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    PROFILED_PATH="$HOME/.nix-profile/etc/profile.d"
else
    PROFILED_PATH="/etc/profiles/per-user/$USER/etc/profile.d"
fi

source "$PROFILED_PATH/hm-session-vars.sh"

if [ -f "$PROFILED_PATH/nix.sh" ]; then
    source "$PROFILED_PATH/nix.sh"
fi

if [ -f "$PROFILED_PATH/command-not-found.sh" ]; then
    source "$PROFILED_PATH/command-not-found.sh"
fi
```

### Plugins

This provide correct path to share directory (where plugins usually stored if installed by
home-manager).

```bash {.bash #zshrc-body}
if [ -d "$HOME/.nix-profile/share" ]; then
    ZSH_PLUGIN_DIR="$HOME/.nix-profile/share"
else
    ZSH_PLUGIN_DIR="/etc/profiles/per-user/$USER/share"
fi
```

### General

Fix some problems with incorrect input handling. See
[this answer](https://askubuntu.com/questions/441744/pressing-enter-produces-m-instead-of-a-newline/452576#452576).

```bash {.bash #zshrc-body}
stty sane
```

Define some env generic variables.

```bash {.bash #zshrc-body}
export LINUX_DISTRO="$(grep ^ID /etc/os-release | cut -d '=' -f2 | tr -d \")"
export PAGER="less"
export MANPAGER="man-pager"
```

Enhance autocompletion

```bash {.bash #zshrc-body}
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
```

Manage command history.

```bash {.bash #zshrc-body}
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_BY_COPY
setopt HIST_IGNORE_DUPS
```

This fix autocompletion for `sudo` commands. See
[this](https://www.reddit.com/r/archlinux/comments/17ss7c9/no_autocomplete_with_sudo/) for more
information

```bash {.bash #zshrc-body}
alias sudo='sudo '
```

### Prompt {starship}

[starship](https://starship.rs/) handle my zsh prompt. Add package to nix module.

```nix {.nix #zsh-packages}
starship
```

And add initialization to zshrc.

```bash {.bash #zshrc-body}
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"
eval "$(starship init zsh)"
```

This my [starship.toml](modules/home/shells/zsh/starship.toml).

```toml {.toml file=modules/home/shells/zsh/starship.toml}
add_newline = true

format = """\
╭$username$directory$git_branch$fill$nix_shell$python$shell
╰$character\
"""

[username]
format = '─⌠ [$user]($style) ⌡'
show_always = true

[character]
format = '$symbol'
success_symbol = '─% '
error_symbol = '─[%](red) '

[directory]
format = '─⌠ [$read_only]($read_only_style)[$path]($style) ⌡'
read_only = ' '

[fill]
symbol = '─'
style = 'fg:gray'

[git_branch]
format = '─⌠ [$symbol$branch]($style) ⌡'
symbol = ' '

[nix_shell]
format = '─⌠ [$symbol$state]($style) ⌡'
symbol = ' '

[python]
format = '─⌠ [$symbol $virtualenv]($style) ⌡'
symbol = ' '

[shell]
zsh_indicator = ''
ion_indicator = '─⌠ [ion]($style) ⌡'
format = '$indicator'
disabled = false
style = 'fg:blue'
```

### Fuzzy Finder {fzf}

[fzf](https://github.com/junegunn/fzf) it's an interactive filter program. Enhance autocompletion
with fzf built-in scripts.

```bash {.bash #zshrc-body}
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --height 40%
    --reverse
    --margin=0,2
    --prompt="➤"
    --pointer="➤"
    --marker="⊕"'

FZF_SHARE_DIR="/usr/share/fzf"
if [ -d $FZF_SHARE_DIR ]; then
  source $FZF_SHARE_DIR"/key-bindings.zsh"
  source $FZF_SHARE_DIR"/completion.zsh"
elif [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
else
  echo "Error: fuzzy finder (fzf) missed"
fi
```

#### Fuzzy Auto Completion {fzf-tab}

Replace zsh's default completion selection menu with fzf. Add fzf-tab to nix packages.

```nix {.nix #zsh-packages}
zsh-fzf-tab
```

And source it in zshrc.

```bash {.bash #zshrc-body}
source "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.zsh"
```

### Editor {neovim}

Settings related to neovim are in a separate file. See
[neovim configuration](<./nvim.md#zsh configuration>)

```bash {.bash #zshrc-body}
source "${XDG_CONFIG_HOME}/zsh/nvim.zsh"
```

### Keybindings

Use emacs style keybindings

```bash {.bash #zshrc-body}
bindkey -e
```

Copy current command to clipboard by pressing <alt-y> or `esc y`.

```bash {.bash #zshrc-body}
function __yank-current-buffer {
    echo "$BUFFER" | wl-copy
}
zle -N __yank-current-buffer
bindkey "\ey" __yank-current-buffer
```

Show full path to current command by pressing <alt-s> or `esc s`.

```bash {.bash #zshrc-body}
function __show-command-source {
    echo "$BUFFER" | awk '{print $1;}' | xargs which | xargs readlink -f | bat --paging=always --pager "less -Rc" --plain
}
zle -N __show-command-source
bindkey "\es" __show-command-source
bindkey -M vicmd "\es" __show-command-source
```

Handle ctrl-left and ctrl-right as backward-word and forward-word respectively.

```bash {.bash #zshrc-body}
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
```

Swap <ctrl-f> and <alt-f> logic (same for <ctrl-b> and <alt-b>)

```bash {.bash #zshrc-body}
bindkey '^f' forward-word
bindkey '^[f' forward-char
bindkey '^b' backward-word
bindkey '^[b' backward-char
```

Treat double escape as sudo.

```bash {.bash #zshrc-body}
__sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N __sudo-command-line
bindkey "\e\e" __sudo-command-line
bindkey -M vicmd '\e\e' __sudo-command-line
```

### Folder Specific Environment {direnv}

Enable direnv support

```nix {.nix #zsh-packages}
direnv
nix-direnv
nix-direnv-flakes
```

```bash {.bash #zshrc-body}
eval "$(direnv hook zsh)"
```

### Syntax Highlighting {zsh-syntax-highlighitng}

Add corresponding package to nix configuration.

```nix {.nix #zsh-packages}
zsh-syntax-highlighting
```

And source it in zshrc.

```bash {.bash #zshrc-body}
source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
```

### Aliases

#### GNU utils replacement

Add corresponding packages to home manager module.

```nix {.nix #zsh-packages}
eza
ripgrep
zoxide
bat
btop
```

And add aliases:

```bash {.bash #zshrc-body}
if [ $+commands[exa] -eq 1 ]; then
  alias ls='exa'
  alias tree='exa --tree'
fi

alias l='ls'
alias ll='ls -lh'
alias lla='ls -lah'

if [ $+commands[rg] -eq 1 ]; then
  alias grep='rg';
fi

if [ $+commands[zoxide] -eq 1 ]; then
  eval "$(zoxide init zsh)";
  alias cdd='zi';
fi

if [ $+commands[bat] -eq 1 ]; then
  alias cat='bat --plain';
fi

if [ $+commands[btop] -eq 1 ]; then
  alias htop='btop'
fi
```

#### Git aliases

Add git to package list.

```nix {.nix #zsh-packages}
git
```

And add aliases to zshrc.

```bash {.bash #zshrc-body}
alias g='git'
alias gp='g pull'
alias gP='g push'
alias gs='g status -s'
alias gss='g status'
alias gd='g diff'
alias gb='g branch'
alias ga='g add'
alias gaa='g add --all'
alias gcm='g commit -m'
alias gc='g checkout'
alias grH='g reset --hard'
alias glg='git-log-graph'
alias gPP='g push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gcb='g checkout -b'
alias gcF='g clean -xdf'
alias gI='g init'
alias gC='g clone'
alias goo='git-open-origin'
alias gR='git reset HEAD'
alias grs='git restore --staged'
```

#### Nix Aliases

```bash {.bash #zshrc-body}
alias nix-search-cache='nix-env -qa --json > /tmp/.nix-search-cache'
alias nix-search='nix search nixpkgs --offline'
alias nixos-up='nixos-rebuild switch --flake ~/dotfiles'
alias hm='home-manager'
alias hm-up='pushd; cd ~/dotfiles; just switch-home; popd'
alias hm-up-pure='pushd; cd ~/dotfiles; just switch-home-pure; popd'
alias na='nix-alien'
alias nix-sp='nix-shell --run zsh -p'
alias nltl='nix-locate --top-level'
```

#### Network Aliases

```bash {.bash #zshrc-body}
alias extract-ip="cut -d ' ' -f 2"
alias local-ip="ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f 1"
alias default-network-device="route | grep '^default' | grep -o '[^ ]*$'"

function local-ip-grep() {
  local-ip | grep $1 | extract-ip
}

alias local-ip-default='local-ip-grep $(default-network-device)'
```

#### Archive Aliases

```bash {.bash #zshrc-body}
alias unpack='dtrx'
alias pack-zip='zip'
alias pack-tar-gz='tar -czvf'
alias unzip='7za x'
alias untargz='tar -xvzf'
```

#### ADB Aliases

```bash {.bash #zshrc-body}
alias adb-ip="adb shell ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f 1"
alias extract-ip="cut -d ' ' -f 2"

function adb-ip-grep {
  adb-ip | grep $1 | extract-ip
}

export ANDROID_SERIAL="$(cat /tmp/android_serial 2>/dev/null)"

alias adb-fzf-ip="adb-ip | fzf | extract-ip"
alias adb-fzf-app='adb shell pm list packages | cut -c 9- | fzf'
alias adb-fzf-prune='adb-fzf-app | xargs --no-run-if-empty adb-prune-app'
alias adb-fzf-device="adb devices -l | awk 'NR>1 && NF' | fzf | awk '{ print \$1 }'"
alias adb-select-device='export ANDROID_SERIAL=$(adb-fzf-device)'
alias adb-select-device-global='export ANDROID_SERIAL=$(adb-fzf-device); echo "$ANDROID_SERIAL" > /tmp/android_serial'
alias adb-reset-device-global='rm --force /tmp/android_serial && export ANDROID_SERIAL=""'

function adb-type {
  adb shell "input text '$@' && input keyevent 66"
}
```

#### Misc Aliases

```bash {.bash #zshrc-body}
alias ..='cd ..'
alias info='info --vi-keys'
alias copyit='wl-copy'
alias cp-path='pwd | wl-copy'
alias cl='clear'
alias md='mkdir'
alias chx='chmod +x'
alias r='ranger-zoxide'
alias zsh-up='reset && source ~/.zshrc'
alias ssh='TERM=xterm-256color ssh'
alias open='xdg-open'
alias ra='radare2 -A'
alias tmux-up="tmux source ${XDG_CONFIG_HOME}/tmux/tmux.conf"
```
