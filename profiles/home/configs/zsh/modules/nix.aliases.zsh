
alias nix-search-cache='nix-env -qa --json > /tmp/.nix-search-cache'
alias nix-search='nix search nixpkgs --offline'
alias nixos-up='nixos-rebuild switch --flake ~/dotfiles#home-pc'
alias hm='home-manager'
alias hm-up='home-manager switch --flake ~/dotfiles#home'
alias nix-sp='nix-shell --run zsh -p'
