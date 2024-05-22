{ config, pkgs, ... }:

{
  imports =
    [
      ./nix.nix
      ./kernel.nix
      ./services.nix
      ./packages.nix
      ./network.nix
      ./user.nix
      ./virtualization.nix
      ./gaming.nix
    ];
}
