{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
      vim
  ];

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Ubuntu" ]; })
    ];
    fontconfig.enable = true;
  };
}
