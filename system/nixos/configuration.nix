{ config, pkgs, ... }:

{
  imports =
    [
      ./machine-specific.nix
      ./i18n.nix
      ./services.nix
      ./packages.nix
      ./user.nix
      ./network.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "22.11";
}
