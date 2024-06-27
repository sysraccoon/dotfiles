username := env_var("USER")
hostname := `hostname`
export IMPURITY_PATH := `pwd`

default:
  just --list

alias switch-home := switch-home-impure

switch-home-pure home-config=username:
  home-manager switch --flake .#{{home-config}}

switch-home-impure impure-home-config=(username + "-impure"):
  home-manager switch --impure --flake .#{{impure-home-config}}

switch-nixos nixos-config=hostname:
  nixos-rebuild switch --flake .#{{nixos-config}}

build-live-image:
  nix build .#nixosConfigurations.live-image.config.system.build.isoImage

