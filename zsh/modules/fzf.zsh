# enable fuzzy finder features if exists
export FZF_DEFAULT_OPTS='--height 40% --reverse --margin=0,2'

# nord theme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

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

