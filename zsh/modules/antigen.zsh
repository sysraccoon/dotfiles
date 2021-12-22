ANTIGEN_DIR="$ZSH_CONFIG_DIR/antigen"
mkdir -p $ANTIGEN_DIR;

if ! [ -f "$ANTIGEN_DIR/antigen.zsh" ]; then
  echo "Error: antigen missed. Try installing...";
  curl -vL git.io/antigen > "$ANTIGEN_DIR/antigen.zsh";
fi

source "$ANTIGEN_DIR/antigen.zsh";

if [ -f "$ANTIGEN_DIR/antigenrc" ]; then
  antigen init "$ANTIGEN_DIR/antigenrc";
else
  echo "Error: $ANTIGEN_DIR/antigenrc missed";
fi

