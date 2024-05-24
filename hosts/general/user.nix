{ config, pkgs, ... }:

{
  users.users.raccoon = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      home-manager
      neovim
      git
      gh
      zsh
      htop
    ];
  };
}
