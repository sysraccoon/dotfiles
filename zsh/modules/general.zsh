autoload -U colors && colors

export LINUX_DISTRO="$( grep ^ID /etc/os-release | cut -d '=' -f2 | tr -d \" )"
export PROMPT="
╭─%{$fg[cyan]%}⌠ %n ⌡%{$reset_color%}─%{$fg[cyan]%}⌠ %~ ⌡
%{$reset_color%}╰─%# "

export LANG=en_US.UTF-8
export PAGER=less
export PATH=$PATH:"$HOME/linuxbrew/.linuxbrew/bin"
export PATH=$PATH:"$HOME/bin"
export PATH=$PATH:"$HOME/.local/bin"

export EDITOR=$(command -v vim)
alias e=$EDITOR

# zsh autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,bg=black,underline"
bindkey '^ ' autosuggest-accept

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

# use binutils alternatives if exists
command -v rg >/dev/null 2>&1 && { alias grep='rg' }
command -v zoxide >/dev/null 2>&1 && { 
  eval "$(zoxide init zsh)"
  alias cd='z';
}
command -v bat >/dev/null 2>&1 && { alias cat='bat' }

# other aliases
alias sudo='sudo '
alias belloff='rmmod pcspkr'

alias upzsh='source ~/.zshrc'
alias ezsh=$EDITOR' $(find $ZSH_CONFIG_DIR -follow | fzf) && upzsh'

alias copyit='xclip -sel clip'
alias unzip='7za x'
alias reloadscreen='xrandr --output HDMI2 --off; xrandr --output HDMI2 --right-of eDP1 --auto; ~/.launchers/polybar.sh'

alias xxi='xbps-install -Sy'
alias xxq='xbps-query -Rs'

alias c='clear'

alias adb-run-frida='adb shell su -c "frida-server-15.1.6-android-arm64 -l 0.0.0.0 &"'

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
