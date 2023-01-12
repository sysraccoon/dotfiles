{ config, pkgs, ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
}
