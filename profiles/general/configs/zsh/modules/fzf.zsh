# enable fuzzy finder features if exists
export FZF_DEFAULT_OPTS='--height 40% --reverse --margin=0,2'

# modify cursors style
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --prompt="➤"
    --pointer="➤"
    --marker="⊕"'

FZF_SHARE_DIR="/usr/share/fzf"
if [ -d $FZF_SHARE_DIR ]; then
  source $FZF_SHARE_DIR"/key-bindings.zsh"
  source $FZF_SHARE_DIR"/completion.zsh"
elif [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
else
  echo "Error: fuzzy finder (fzf) missed"
fi

