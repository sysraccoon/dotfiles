{ config, pkgs, bundles, ... }:

{
  imports =
    [
      bundles.general.nixosModules.default
      ../general/configuration.nix
      ./hardware-configuration.nix
      ./machine-specific.nix
    ];

  system.stateVersion = "22.11";
  networking.hostName = "thinkpad-yoga";
}
