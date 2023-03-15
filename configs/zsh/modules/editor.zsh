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
alias nvim='nvim -w $STAT_DIR/nvim/$(date "+%Y-%m-%d:%H-%M-%S")'
alias vim='nvim'
alias vi='nvim'
alias e='nvim'
alias nano='nvim'

alias edot="nvim \$DOTFILES_DIR +':cd %' +':Telescope find_files'"

alias edit='e'
