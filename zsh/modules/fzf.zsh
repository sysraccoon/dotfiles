# enable fuzzy finder features if exists
export FZF_DEFAULT_OPTS='--reverse'
FZF_SHARE_DIR="/usr/share/fzf"
if [ -d $FZF_SHARE_DIR ]; then
  source $FZF_SHARE_DIR"/key-bindings.zsh"
  source $FZF_SHARE_DIR"/completion.zsh"
else
  echo "Error: fuzzy finder (fzf) missed"
fi

