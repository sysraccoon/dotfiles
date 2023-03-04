export NIX_PATH="$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}"

source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

if [ -f "$HOME/.nix-profile/etc/profile.d/command-not-found.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/command-not-found.sh"
fi

