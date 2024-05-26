{
  config,
  lib,
  ...
}: let
  cfg = config.sys.nixos.network;
in {
  options.sys.nixos.network = {
    enable = lib.mkEnableOption "toggle custom network setup";
    networkUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "users that need add to network related groups";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;
    networking.dhcpcd.wait = "background";
    networking.dhcpcd.extraConfig = "noarp";

    networking.firewall.enable = true;

    users.groups.networkmanager = {
      members = cfg.networkUsers;
    };

    networking.enableIPv6 = true;
  };
}
