# config.zsh

# If not running interactively, don't do anything
[[ $- != *i* ]] && {
  >&2 echo "interactive mode didn't support"
  exit 1;
}

export ZSH_CONFIG_DIR="$HOME/dotfiles/zsh"

MODULES=(
  # applications
  "xorg" # x11 features

  # external dependencies
  "antigen"

  # other
  "general" # enable general features
  "work" # work specific features (ignored in .gitignore)

  # tools
  "fzf" # fuzzy finder
  "term-hotkeys" # enhance term hotkeys

  # languages
  "rust" # rust features
  "python" # python features
)

for module in ${MODULES[@]}; do
  if [[ -f "$ZSH_CONFIG_DIR/modules/$module.zsh" ]]; then
    source "$ZSH_CONFIG_DIR/modules/$module.zsh";
  fi
done

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/raccoon/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/raccoon/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/raccoon/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/raccoon/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

