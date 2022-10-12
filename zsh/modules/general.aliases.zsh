
alias ls='ls --color=auto'
alias l='ls'
alias sl='ls'
alias s='ls'

alias ll='ls -lah'

alias info='info --vi-keys'

alias ducks='du -cks * | sort -rn | head -11 | numfmt --to=iec-i --suffix=B'
alias addgroup='gpasswd -a $(whoami) $1'

alias copyit='cb-set'
alias cp-path='pwd | cb-set'

alias unzip='7za x'
alias cl='clear'
alias md='mkdir'
alias me='chmod +x'
alias co='curl -O'
alias r='ranger-zoxide'

alias zsh-up='source ~/.zshrc'
alias psgrep='ps aux | grep'

alias ssh='TERM=xterm-256color ssh'

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

alias sudo='sudo ' # autocompletion hack

if [ $+commands[doas] -eq 1 ]; then
  alias sudo='doas '
fi

alias reload-screen='xrandr --output HDMI2 --off; xrandr --output HDMI2 --right-of eDP1 --auto; ~/.launchers/polybar.sh'
alias screencast-mode='xrandr --output HDMI-A-0 --mode 1920x1080 && reloadscreen'
alias screen-normal-mode='xrandr --output HDMI-A-0 --mode 2560x1080 && reloadscreen'
