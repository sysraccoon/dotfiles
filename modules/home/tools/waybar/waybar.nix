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
  };

  config = lib.mkIf cfg.enable {
    programs.waybar.enable = true;

    xdg.configFile."waybar/config".source = impurity.link ./config;
    xdg.configFile."waybar/theme.css".source = impurity.link ./theme.css;

    xdg.configFile."waybar/style.css".text = let
      colors = config.lib.stylix.colors.withHashtag;
      palette = ''
        @define-color color0 ${colors.base00};
        @define-color color1 ${colors.base01};
        @define-color color2 ${colors.base02};
        @define-color color3 ${colors.base03};
        @define-color color4 ${colors.base04};
        @define-color color5 ${colors.base05};
        @define-color color6 ${colors.base06};
        @define-color color7 ${colors.base07};
        @define-color color8 ${colors.base08};
        @define-color color9 ${colors.base09};
        @define-color color10 ${colors.base10};
        @define-color color11 ${colors.base11};
        @define-color color12 ${colors.base12};
        @define-color color13 ${colors.base13};
        @define-color color14 ${colors.base14};
        @define-color color15 ${colors.base15};
      '';
      complete-style = ''
        ${palette}

        @import url("theme.css");
      '';
    in
      complete-style;

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

    # prefer to manual customize waybar style
    stylix.targets.waybar.enable = false;
  };
}
