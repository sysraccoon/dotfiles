{ config, pkgs, ... }:

{
  imports =
    [
      ./nix.nix
      ./machine-specific.nix
      ./kernel.nix
      ./i18n.nix
      ./services.nix
      ./packages.nix
      ./network.nix
      # ./virtualization.nix
      ./user.nix
    ];

  system.stateVersion = "22.11";
}
