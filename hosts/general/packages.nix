{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fuse
    ntfs3g
    vim
  ];

  programs.zsh.enable = true;
  programs.wireshark.enable = true;
}
