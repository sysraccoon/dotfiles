export NIX_PATH="$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}"


if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
    PROFILED_PATH="$HOME/.nix-profile/etc/profile.d"
else
    PROFILED_PATH="/etc/profiles/per-user/$USER/etc/profile.d"
fi

source $PROFILED_PATH/hm-session-vars.sh

if [ -f "$PROFILED_PATH/nix.sh" ]; then
    source "$PROFILED_PATH/nix.sh"
fi

if [ -f "$PROFILED_PATH/command-not-found.sh" ]; then
    source "$PROFILED_PATH/command-not-found.sh"
fi

