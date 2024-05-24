{ config, lib, pkgs, ... }:

let
  cfg = config.sys.nixos.mainUser;
in {
  options.sys.nixos.mainUser = {
    enable = lib.mkEnableOption "toggle custom user setup";
    username = lib.mkOption {
      type = lib.types.str;
      description = "set name used by this user";
    };
    isSuperUser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "add user to wheel group";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = lib.mkIf cfg.isSuperUser [ "wheel" ];
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
  };
}
