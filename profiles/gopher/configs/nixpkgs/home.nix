{ config, pkgs, lib, host-profile, overlays, ... }:

{

  imports = [
    ../../../general/configs/nixpkgs/home.nix
  ];

  home.stateVersion = "22.11";

  home.username = "gopher";
  home.homeDirectory = "/home/gopher";
}
