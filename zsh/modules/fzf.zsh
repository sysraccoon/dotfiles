# enable fuzzy finder features if exists
FZF_SHARE="/usr/share/fzf"
if [ -d $FZF_SHARE ]; then
  source $FZF_SHARE"/key-bindings.zsh"
  source $FZF_SHARE"/completion.zsh"
else
  echo "Error: fuzzy finder (fzf) missed"
fi

