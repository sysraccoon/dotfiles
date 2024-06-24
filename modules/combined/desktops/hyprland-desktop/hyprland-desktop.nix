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
    imports = [
      inputs.hyprland.nixosModules.default
    ];

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
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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
    imports = lib.optionals isStandaloneHome [
      inputs.hyprland.homeManagerModules.default
    ];

    options.sys.home.desktops.hyprland-desktop = {
      enable = lib.mkEnableOption "enable custom hyprland setup";
      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };

    config = lib.mkIf cfg.enable {
      wayland.windowManager.hyprland = let
        stylixColors = config.lib.stylix.colors;
        colorOverrides = pkgs.writeText "color-overrides.conf" ''
          plugin:hy3:tabs {
            col.active = 0xaa${stylixColors.base09}
          }
        '';
      in {
        enable = true;
        xwayland.enable = true;
        plugins = [
          inputs.hy3.packages.${pkgs.system}.default
        ];

        extraConfig = ''
          source = ${impurity.link ./hyprland.conf}
          source = ${colorOverrides}
          ${cfg.extraConfig}
        '';
      };

      gtk.enable = true;

      home.packages = with pkgs; [
        # wayland specific apps
        cliphist
        swaybg
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

      # hotfix breaking change of hyprland v0.40.0
      # see release page: https://github.com/hyprwm/Hyprland/releases/tag/v0.40.0
      home.activation.fix-hyprland-runtime-dir = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ln -sf $XDG_RUNTIME_DIR/hypr /tmp/hypr
      '';

      home.file.".background-image".source = impurity.link ../resources/wallpapers/default.jpg;

      stylix.targets.hyprland.enable = true;

      sys.home.tools.rofi.enable = lib.mkDefault true;
      sys.home.tools.waybar.enable = lib.mkDefault true;
    };
  };
}
