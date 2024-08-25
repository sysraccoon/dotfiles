{
  config,
  pkgs,
  lib,
  impurity,
  ...
}: let
  cfg = config.sys.home.tools.waybar;
in {
  options.sys.home.tools.waybar = {
    enable = lib.mkEnableOption "toggle custom waybar setup";
    config = lib.mkOption {
      type = lib.types.path;
      default = ./config;
      description = "set custom config";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.waybar.enable = true;

    xdg.configFile."waybar/config".source = impurity.link cfg.config;
    xdg.configFile."waybar/style.css".source = impurity.link ./style.css;

    # Simple oneshot service, that restart waybar, used by waybar-config-watcher.path
    systemd.user.services.waybar-config-reloader = {
      Unit = {
        Description = "Waybar Config Reloader";
      };
      Service = {
        Type = "oneshot";
        # Do not direct pkill -SIGUSR2 waybar, because it cause this message:
        # > The user systemd session is degraded:
        # > UNIT                           LOAD   ACTIVE SUB    DESCRIPTION
        # > ● waybar-config-reloader.service loaded failed failed Waybar Config Reloader
        # On "home-manager switch" if waybar actually not running
        ExecStart = ''
          /bin/sh -c '${pkgs.procps}/bin/pkill -SIGUSR2 waybar || true'
        '';
      };
    };

    # This systemd path, watch changes on waybar related files and automatically
    # trigger waybar-config-reloader
    systemd.user.paths.waybar-config-watcher = {
      Unit = {
        Description = "Waybar Config Watcher";
      };
      Path = {
        PathModified = let
          waybarDir = "${config.xdg.configHome}/waybar";
        in [
          waybarDir
          "${waybarDir}/style.css"
          "${waybarDir}/theme.css"
          "${waybarDir}/config"
        ];
        TriggerLimitIntervalSec = "5s";
        Unit = "waybar-config-reloader.service";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
