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

  # languages
  "rust" # rust features
  "python" # python features

  # terminal
  "term-hotkeys" # enhance terminal hotkeys
  "widgets"
  # "tmux"

  # tools
  "fzf" # fuzzy finder
  "pacman" # pacman package manager
  "yay" # yay package manager
  "editor" # setup vim

  # other
  "general" # enable general features
  "prompt" # enhance prompt
  # "work" # work specific features (ignored in .gitignore)

  # external dependencies
  "antigen"

  # aliases
  "general.aliases"
  "git.aliases"
  "network.aliases"
)

for module in ${MODULES[@]}; do
  if [[ -f "$ZSH_CONFIG_DIR/modules/$module.zsh" ]]; then
    source "$ZSH_CONFIG_DIR/modules/$module.zsh";
  fi
done

