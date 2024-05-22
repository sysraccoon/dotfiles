{ config, pkgs, ... }:

{
  imports =
    [
      ./kernel.nix
      ./services.nix
      ./packages.nix
      ./network.nix
      ./user.nix
      ./virtualization.nix
      ./gaming.nix
    ];
}
