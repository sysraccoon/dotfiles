{ config, pkgs, ... }:

{
  imports =
    [
      ../general/configuration.nix
      ./hardware-configuration.nix
      ./machine-specific.nix
    ];

  system.stateVersion = "22.11";
  networking.hostName = "home-pc";
}
