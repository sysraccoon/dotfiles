{ config, pkgs, ... }:

{
  users.users.raccoon = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      home-manager
      neovim
      git
      gh
      zsh
      htop
      wireshark
    ];
  };
}
