{
  config,
  pkgs,
  lib,
  impurity,
  ...
}: let
  cfg = config.sys.home.tools.swaybg;
in {
  options.sys.home.tools.swaybg = {
    enable = lib.mkEnableOption "toggle custom swaybg setup";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.swaybg = {
      Unit = {
        Description = "Custom swaybg service";
      };
      Service = {
        ExecStart = ''
          ${pkgs.swaybg}/bin/swaybg \
            --output "*" --mode fill --image '${impurity.link ./wallpapers/default.png}' \
            --output "HDMI-A-1" --mode fill --image '${impurity.link ./wallpapers/right.png}'
        '';
      };
    };
  };
}
