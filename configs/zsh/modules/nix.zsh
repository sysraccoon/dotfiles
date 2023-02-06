export NIX_PATH="$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}"

alias enixos="nvim /etc/nixos +':cd %' +':Telescope find_files'"
alias nixos-up='nixos-rebuild switch'
alias hm-up='home-manager switch'
alias ehm='home-manager edit'

source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
