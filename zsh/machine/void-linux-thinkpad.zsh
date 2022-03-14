# config.zsh

# If not running interactively, don't do anything
[[ $- != *i* ]] && {
  >&2 echo "interactive mode didn't support"
  exit 1;
}

export DOTFILES_DIR="$HOME/dotfiles"
export ZSH_CONFIG_DIR="$HOME/dotfiles/zsh"

MODULES=(
  # applications
  "xorg" # x11 features

  # external dependencies
  "antigen"

  # terminal
  "term-hotkeys" # enhance term hotkeys
  "widgets" # custom zsh widgets

  # other
  "general" # enable general features
  "prompt"
  "work" # work specific features (ignored in .gitignore)

  # tools
  "fzf" # fuzzy finder
  "xbps" # void package manager

  # languages
  "rust" # rust features
  "python" # python features
)

for module in ${MODULES[@]}; do
  if [[ -f "$ZSH_CONFIG_DIR/modules/$module.zsh" ]]; then
    source "$ZSH_CONFIG_DIR/modules/$module.zsh";
  fi
done

