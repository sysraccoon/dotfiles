{ config, pkgs, lib, ... }:
let
  cfg = config.sys.nixos.programs.syncthing;
in {
  options.sys.nixos.programs.syncthing = {
    enable = lib.mkEnableOption "toggle custom syncthing setup";
    user = lib.mkOption {
      type = lib.types.str;
      description = "user that run syncthing";
    };
    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/${cfg.user}/.config/syncthing";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.configDir}/db";
    };
    openDefaultPorts = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open default ports that used by syncthing";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "raccoon";
      configDir = cfg.configDir;
      dataDir = cfg.dataDir;
    };

    networking.firewall = lib.mkIf cfg.openDefaultPorts {
      allowedTCPPorts = [ 8384 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
    };
  };
}