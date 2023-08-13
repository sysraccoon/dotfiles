{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fuse
    ntfs3g
    vim

    libsForQt5.bismuth
  ];

  programs.zsh.enable = true;
}
