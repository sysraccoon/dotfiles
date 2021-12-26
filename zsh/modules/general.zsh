autoload -Uz compinit && compinit
autoload -U colors && colors

export LINUX_DISTRO="$( grep ^ID /etc/os-release | cut -d '=' -f2 | tr -d \" )"
export PROMPT="
╭─%{$fg[cyan]%}⌠ %n ⌡%{$reset_color%}─%{$fg[cyan]%}⌠ %~ ⌡
%{$reset_color%}╰─%# "

export LANG=en_US.UTF-8
export PAGER=less
export PATH=$PATH:"$HOME/bin"
export PATH=$PATH:"$HOME/.local/bin"

export MANPAGER="man-pager";

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"

export EDITOR=$(command -v vim)
alias e=$EDITOR

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# history managment
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt histignorealldups

# default commands enhancments
alias ls='ls --color=auto'
alias l='ls'
alias sl='ls'
alias s='ls'

alias info='info --vi-keys'

alias ducks='du -cks * | sort -rn | head -11'
alias addgroup='gpasswd -a $(whoami) $1'

function command-exists {
  command -v rg >/dev/null 2>&1 
}

# use binutils alternatives if exists
command -v rg >/dev/null 2>&1 && { alias grep='rg' }
command -v zoxide >/dev/null 2>&1 && { 
  eval "$(zoxide init zsh)";
  alias cd='z';
}
command -v bat >/dev/null 2>&1 && {
  alias cat='bat';
}


# other aliases
alias sudo='sudo '
command-exists && {
  alias sudo='doas'
}

alias belloff='rmmod pcspkr'

alias upzsh='source ~/.zshrc'
alias ezsh=$EDITOR' $(find $ZSH_CONFIG_DIR -follow | fzf) && upzsh'

alias copyit='xclip -sel clip'
alias unzip='7za x'
alias reloadscreen='xrandr --output HDMI2 --off; xrandr --output HDMI2 --right-of eDP1 --auto; ~/.launchers/polybar.sh'

alias xxi='xbps-install -Sy'
alias xxq='xbps-query -Rs'

alias c='clear'

alias local-ip="ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f 1"
alias adb-ip="adb shell ip -4 -o a | cut -d ' ' -f 2,7 | cut -d '/' -f 1"
alias extract-ip="cut -d ' ' -f 2"
alias default-network-device="route | grep '^default' | grep -o '[^ ]*$'"

function local-ip-grep() {
  local-ip | grep $1 | extract-ip
}

alias local-ip-default='local-ip-grep $(default-network-device)'

function adb-ip-grep() {
  adb-ip | grep $1 | extract-ip
}

alias adb-fzf-ip="adb-ip | fzf | extract-ip"
alias adb-fzf-app='adb shell pm list packages | cut -c 9- | fzf'
alias adb-fzf-prune='adb-fzf-app | xargs --no-run-if-empty adb-prune-app'

alias wifi-list='wpa_cli -i $(default-network-device) list_networks'
