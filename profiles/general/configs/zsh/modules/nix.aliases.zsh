
alias nix-search-cache='nix-env -qa --json > /tmp/.nix-search-cache'
alias nix-search='nix search nixpkgs --offline'
alias nixos-up='nixos-rebuild switch --flake ~/dotfiles'
alias hm='home-manager'
alias hm-up='home-manager switch --flake ~/dotfiles'
alias nix-sp='nix-shell --run zsh -p'
