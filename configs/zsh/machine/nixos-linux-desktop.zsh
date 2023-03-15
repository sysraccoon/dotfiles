# config.zsh

# If not running interactively, don't do anything
[[ $- != *i* ]] && {
  >&2 echo "interactive mode didn't support"
  exit 1;
}

export DOTFILES_DIR="$HOME/dotfiles"
export ZSH_CONFIG_DIR="$HOME/dotfiles/configs/zsh"

MODULES=(
  "nix"
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
  "nix.aliases"

  # aliases and env variables for AOSP project
  "aosp"

  "office.aliases"

  # vscodium code helpers
  "vscodium"

  "direnv"

  "screencast"
)

for module in ${MODULES[@]}; do
  if [[ -f "$ZSH_CONFIG_DIR/modules/$module.zsh" ]]; then
    source "$ZSH_CONFIG_DIR/modules/$module.zsh";
  fi
done

