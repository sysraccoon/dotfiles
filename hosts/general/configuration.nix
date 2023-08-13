{ config, pkgs, ... }:

{
  imports =
    [
      ./nix.nix
      ./kernel.nix
      ./i18n.nix
      ./services.nix
      ./packages.nix
      ./network.nix
      ./user.nix
    ];
}
