{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fuse
    ntfs3g
    vim
  ];

  programs.zsh.enable = true;

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Ubuntu" ]; })
    ];
    fontconfig.enable = true;
  };
}
