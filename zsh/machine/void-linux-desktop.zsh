# config.zsh

# If not running interactively, don't do anything
[[ $- != *i* ]] && {
  >&2 echo "interactive mode didn't support"
  exit 1;
}

export ZSH_CONFIG_DIR="$HOME/dotfiles/zsh"

MODULES=(
  # applications
  # "xorg" # x11 features

  # languages
  # "rust" # rust features
  # "python" # python features

  # tools
  "fzf" # fuzzy finder

  # other
  "general" # enable general features
  "term-hotkeys" # enhance terminal hotkeys
  # "work" # work specific features (ignored in .gitignore)

  # external dependencies
  "antigen"
)

for module in ${MODULES[@]}; do
  if [[ -f "$ZSH_CONFIG_DIR/modules/$module.zsh" ]]; then
    source "$ZSH_CONFIG_DIR/modules/$module.zsh";
  fi
done

