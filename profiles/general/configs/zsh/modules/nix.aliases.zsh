
alias nix-search-cache='nix-env -qa --json > /tmp/.nix-search-cache'
alias nix-search='nix search nixpkgs --offline'
alias nixos-up='nixos-rebuild switch'
alias hm='home-manager'
alias hm-up='(export IMPURITY_PATH="${HOME}/dotfiles"; home-manager switch --impure --flake "${IMPURITY_PATH}/.#${USER}-impure")'
alias hm-up-pure='home-manager switch'
alias na='nix-alien'
alias nix-sp='nix-shell --run zsh -p'
