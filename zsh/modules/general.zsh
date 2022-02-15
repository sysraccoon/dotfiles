autoload -Uz compinit && compinit
autoload -U colors && colors

stty sane
export TERMINFO=/usr/share/terminfo toe

export LINUX_DISTRO="$( grep ^ID /etc/os-release | cut -d '=' -f2 | tr -d \" )"
export PROMPT="
╭─%{$fg[cyan]%}⌠ %n ⌡%{$reset_color%}─%{$fg[cyan]%}⌠ %~ ⌡
%{$reset_color%}╰─%# "

export LANG=en_US.UTF-8
export PAGER=less
export PATH=$PATH:"$HOME/bin"
export PATH=$PATH:"$HOME/.local/bin"
export PATH=$PATH:"$HOME/.cargo/bin"
export PATH=$PATH:"$HOME/go/bin"

export MANPAGER="man-pager";

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"

if [ $+commands[nvim] -eq 1 ]; then
    EDITOR=nvim;
elif [ $+commands[vim] -eq 1 ]; then
    EDITOR=vim;
elif [ $+commands[vi] -eq 1 ]; then
    EDITOR=vi;
else
  echo "Warning: editor not found"
fi

export STAT_DIR=$HOME'/.stats'
mkdir -p "$STAT_DIR/nvim"

export EDITOR
alias nvim='nvim -w $STAT_DIR/$(date "+%Y-%m-%d:%H-%M-%S")'
alias vim='nvim'
alias vi='nvim'
alias e='nvim'
alias nano='nvim'

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# history managment
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_BY_COPY
setopt HIST_IGNORE_DUPS

# default commands enhancments
alias ls='ls --color=auto'
alias l='ls'
alias sl='ls'
alias s='ls'

alias info='info --vi-keys'

alias ducks='du -cks * | sort -rn | head -11 | numfmt --to=iec-i --suffix=B'
alias addgroup='gpasswd -a $(whoami) $1'

# use binutils alternatives if exists
if [ $+commands[rg] -eq 1 ]; then
  alias grep='rg';
fi

if [ $+commands[zoxide] -eq 1 ]; then
  eval "$(zoxide init zsh)";
  alias cd='z';
  alias cdd='cd $(zoxide query -l | fzf)';
fi

if [ $+commands[bat] -eq 1 ]; then
  alias cat='bat';
fi

# other aliases

alias sudo='sudo ' # autocompletion hack

if [ $+commands[doas] -eq 1 ]; then
  alias sudo='doas '
fi

alias belloff='rmmod pcspkr'

alias upzsh='source ~/.zshrc'
alias edot="nvim $DOTFILES_DIR +':cd %' +':Telescope find_files'"

alias copyit='cb-set'
alias unzip='7za x'
alias reloadscreen='xrandr --output HDMI2 --off; xrandr --output HDMI2 --right-of eDP1 --auto; ~/.launchers/polybar.sh'

alias c='clear'
alias md='mkdir'
alias r='ranger-zoxide'

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

alias g='git'
alias gp='g pull'
alias gP='g push'
alias gs='g status'
alias gss='g status -s'
alias gd='g diff'
alias gb='g branch'
alias ga='g add'
alias gaa='g add --all'
alias gcm='g commit -m'
alias gc='g checkout'
alias grh='g reset --hard'
alias goo='git-open-origin'

alias screencast-mode='xrandr --output HDMI-A-0 --mode 1920x1080 && reloadscreen'
alias screen-normal-mode='xrandr --output HDMI-A-0 --mode 2560x1080 && reloadscreen'

alias psgrep='ps aux | grep'
alias cp-path='pwd | cb-set'
