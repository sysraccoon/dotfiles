# ~/~ begin <<notes/nvim.md#modules/home/shells/zsh/zsh/nvim.zsh>>[init]
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
alias vim='$EDITOR'
alias vi='$EDITOR'
alias edit='$EDITOR'
alias nano='$EDITOR'
alias e='edit'

alias edot="tmuxinator dotfiles"
alias enotes="tmuxinator notes"
# ~/~ end