{
  nixosModules.default = {
    config,
    pkgs,
    lib,
    inputs,
    ...
  }: let
    cfg = config.sys.nixos.desktops.hyprland-desktop;
  in {
    options.sys.nixos.desktops.hyprland-desktop = {
      enable = lib.mkEnableOption "enable custom hyprland setup";
      isDefaultDesktop = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "set hyprland as default in display manager";
      };
    };

    config = lib.mkIf cfg.enable {
      programs.hyprland = {
        enable = true;
      };
      services.displayManager = lib.mkIf cfg.isDefaultDesktop {
        defaultSession = "hyprland";
      };
    };
  };

  homeManagerModules.default = {
    config,
    pkgs,
    lib,
    impurity,
    inputs,
    isStandaloneHome,
    ...
  }: let
    cfg = config.sys.home.desktops.hyprland-desktop;
  in {
    options.sys.home.desktops.hyprland-desktop = {
      enable = lib.mkEnableOption "enable custom hyprland setup";
      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };

    config = lib.mkIf cfg.enable {
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        plugins = [
          pkgs.hyprlandPlugins.hy3
        ];
        settings.env =
          map
          (key: "${key},${builtins.toString config.home.sessionVariables."${key}"}")
          (builtins.attrNames config.home.sessionVariables);

        extraConfig = ''
          source = ${impurity.link ./hyprland.conf}
          ${cfg.extraConfig}
        '';
      };

      gtk.enable = true;

      home.packages = with pkgs; [
        # wayland specific apps
        cliphist
        wlr-randr
        grim
        slurp
        wl-clipboard
        wlogout
        wlprop
      ];

      xdg.configFile = {
        "hypr/hyprland-modules".source = impurity.link ./hyprland-modules;
        wlogout.source = impurity.link ./wlogout;
      };

      sys.home.tools.rofi.enable = lib.mkDefault true;
      sys.home.tools.waybar.enable = lib.mkDefault true;
    };
  };
}
