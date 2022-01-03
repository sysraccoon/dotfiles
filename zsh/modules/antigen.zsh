ANTIGEN_DIR="$ZSH_CONFIG_DIR/antigen"
mkdir -p $ANTIGEN_DIR;

if ! [ -f "$ANTIGEN_DIR/antigen.zsh" ]; then
  echo "Warning: antigen missed. Try installing...";
  curl -vL git.io/antigen > "$ANTIGEN_DIR/antigen.zsh";
fi

source "$ANTIGEN_DIR/antigen.zsh";

antigen bundle git
antigen bundle hcgraf/zsh-sudo
antigen bundle Aloxaf/fzf-tab
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply
