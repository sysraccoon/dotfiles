{ config, pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.dhcpcd.wait =  "background";
  networking.dhcpcd.extraConfig = "noarp";
}
