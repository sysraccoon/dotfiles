# enable fuzzy finder features if exists
export FZF_DEFAULT_OPTS='--height 40% --reverse --margin=0,2'

# modify cursors style
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --prompt="➤"
    --pointer="➤"
    --marker="⊕"'

# horizon theme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#bababa,bg:#1c1e26,hl:#3fc6de
    --color=fg+:#bababa,bg+:#1c1e26,hl+:#26bbd9
    --color=info:#3fdaa4,prompt:#3fdaa4,pointer:#e95678
    --color=marker:#b48dac,spinner:#29d398,header:#fab795'

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

