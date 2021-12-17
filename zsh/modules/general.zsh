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

# zsh autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#111111,bg=cyan,underline"
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
alias vizsh='vim '$ZSH_CONFIG_DIR

alias copyit='xclip -sel clip'
alias wifilist='wpa_cli -i wlp4s0 list_networks'
alias unzip='7za x'
alias reloadscreen='xrandr --output HDMI2 --off; xrandr --output HDMI2 --right-of eDP1 --auto; ~/.launchers/polybar.sh'
alias ida='wine ~/store/programs/wine/ida_pro/ida64.exe'
alias ghidra='~/store/programs/ghidra_10.0.2_PUBLIC/ghidraRun'

alias xxi='xbps-install -Sy'
alias xxq='xbps-query -Rs'

alias ipshow='ip -o -f inet  address show'
alias adbip='adb shell ip -o -f inet  address show'

alias adb-fzf='adb shell pm list packages | cut -c 9- | fzf'
alias adb-fzf-prune='adb-fzf | xargs --no-run-if-empty adb-prune-app.sh'
