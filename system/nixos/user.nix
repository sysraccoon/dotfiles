{ config, pkgs, ... }:

{
  users.users.raccoon = {
    isNormalUser = true;
    description = "raccoon";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      home-manager
      firefox
      neovim
      git
      gh
      zsh
      htop
    ];
  };
}
