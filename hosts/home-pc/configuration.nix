{ config, pkgs, ... }:

{
  imports =
    [
      ./machine-specific.nix
      ./kernel.nix
      ./i18n.nix
      ./services.nix
      ./packages.nix
      ./network.nix
      # ./virtualization.nix
      ./user.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "22.11";
}
