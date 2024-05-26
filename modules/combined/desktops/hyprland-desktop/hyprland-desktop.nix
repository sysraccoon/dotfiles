{
  nixosModules.default = {
    config,
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
      programs.hyprland.enable = true;
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
    ...
  }: let
    cfg = config.sys.home.desktops.hyprland-desktop;
  in {
    imports = [
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
      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        plugins = [
          inputs.hy3.packages.${pkgs.system}.default
        ];

        extraConfig = ''
          source = ${impurity.link ./hyprland.conf}
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
        waybar
      ];

      xdg.configFile = {
        "hypr/hyprland-modules".source = impurity.link ./hyprland-modules;
        waybar.source = impurity.link ./waybar;
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
    };
  };
}
