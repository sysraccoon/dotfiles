# ~/~ begin <<notes/zsh.md#modules/home/shells/zsh/zsh/config.zsh>>[init]
# ~/~ begin <<notes/zsh.md#zshrc-body>>[init]
[[ $- != *i* ]] && {
  >&2 echo "interactive mode didn't support"
  exit 1;
}
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[1]
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
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[2]
if [ -d "$HOME/.nix-profile/share" ]; then
    ZSH_PLUGIN_DIR="$HOME/.nix-profile/share"
else
    ZSH_PLUGIN_DIR="/etc/profiles/per-user/$USER/share"
fi
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[3]
stty sane
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[4]
export LINUX_DISTRO="$(grep ^ID /etc/os-release | cut -d '=' -f2 | tr -d \")"
export PAGER="less"
export MANPAGER="man-pager"
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[5]
# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[6]
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_BY_COPY
setopt HIST_IGNORE_DUPS
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[7]
alias sudo='sudo '
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[8]
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
eval "$(starship init zsh)"
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[9]
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
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[10]
source "$ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.zsh"
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[11]
source "${XDG_CONFIG_DIR:-$HOME/.config}/zsh/nvim.zsh"
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[12]
bindkey -e
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[13]
function __yank-current-buffer {
    echo "$BUFFER" | wl-copy
}
zle -N __yank-current-buffer
bindkey "\ey" __yank-current-buffer
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[14]
function __show-command-source {
    echo "$BUFFER" | awk '{print $1;}' | xargs which | xargs readlink -f | bat --paging=always --pager "less -Rc" --plain
}
zle -N __show-command-source
bindkey "\es" __show-command-source
bindkey -M vicmd "\es" __show-command-source
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[15]
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[16]
bindkey '^f' forward-word
bindkey '^[f' forward-char
bindkey '^b' backward-word
bindkey '^[b' backward-char
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[17]
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
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[18]
eval "$(direnv hook zsh)"
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[19]
source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[20]
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
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[21]
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
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[22]
alias nix-search-cache='nix-env -qa --json > /tmp/.nix-search-cache'
alias nix-search='nix search nixpkgs --offline'
alias nixos-up='nixos-rebuild switch --flake ~/dotfiles'
alias hm='home-manager'
alias hm-up='pushd; cd ~/dotfiles; just switch-home; popd'
alias hm-up-pure='pushd; cd ~/dotfiles; just switch-home-pure; popd'
alias na='nix-alien'
alias nix-sp='nix-shell --run zsh -p'
alias nltl='nix-locate --top-level'
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[23]
alias extract-ip="cut -d ' ' -f 2"
alias local-ip="ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f 1"
alias default-network-device="route | grep '^default' | grep -o '[^ ]*$'"

function local-ip-grep() {
  local-ip | grep $1 | extract-ip
}

alias local-ip-default='local-ip-grep $(default-network-device)'
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[24]
alias unpack='dtrx'
alias pack-zip='zip'
alias pack-tar-gz='tar -czvf'
alias unzip='7za x'
alias untargz='tar -xvzf'
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[25]
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
# ~/~ end
# ~/~ begin <<notes/zsh.md#zshrc-body>>[26]
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
alias tmux-up="tmux source ${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
# ~/~ end
# ~/~ end