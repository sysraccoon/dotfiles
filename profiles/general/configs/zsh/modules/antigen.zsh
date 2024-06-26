ANTIGEN_DIR="$XDG_DATA_HOME/antigen"
ANTIGEN_SCRIPT="$ANTIGEN_DIR/antigen.zsh"
mkdir -p $ANTIGEN_DIR;

if [ ! -s "$ANTIGEN_SCRIPT" ] ; then
  echo "Warning: antigen missed. Try installing...";
  curl -vL git.io/antigen > "$ANTIGEN_SCRIPT";
fi

if [ -s "$ANTIGEN_SCRIPT" ] ; then
  source "$ANTIGEN_SCRIPT";

  antigen bundle hcgraf/zsh-sudo
  antigen bundle Aloxaf/fzf-tab
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle marlonrichert/zsh-autocomplete

  antigen apply
else
  echo "Error: $ANTIGEN_SCRIPT missed. Failed to install zsh plugins"
fi
