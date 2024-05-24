{ config, lib, ... }:
let
  cfg = config.sys.nixos.programs.wireshark;
in {
  options.sys.nixos.programs.wireshark = {
    enable = lib.mkEnableOption "toggle wireshark custom setup";
    wiresharkUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wireshark.enable = true;

    users.groups.wireshark = {
      members = cfg.wiresharkUsers;
    };
  };
}
