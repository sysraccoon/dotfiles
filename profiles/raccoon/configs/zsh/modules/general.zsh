stty sane

source "$HOME/.profile"

export LINUX_DISTRO="$(grep ^ID /etc/os-release | cut -d '=' -f2 | tr -d \")"

export PAGER="less"

export MANPAGER="man-pager"

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

