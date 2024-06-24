{
  nixosModules.default = {
    config,
    lib,
    inputs,
    ...
  }: let
    cfg = config.sys.nixos.stylix;
    wallpaper = ../../modules/combined/desktops/resources/wallpapers/default.jpg;
  in {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];

    options.sys.nixos.stylix = {
      enable = lib.mkEnableOption "toggle custom stylix setup";
    };

    config = {
      stylix.enable = cfg.enable;
      stylix.autoEnable = false;
      stylix.image = wallpaper;
      stylix.homeManagerIntegration = {
        autoImport = true;
        followSystem = false;
      };
    };
  };

  homeManagerModules.default = {
    config,
    pkgs,
    lib,
    inputs,
    isStandaloneHome,
    ...
  }: let
    cfg = config.sys.home.stylix;
  in {
    imports = lib.optionals isStandaloneHome [
      inputs.stylix.homeManagerModules.stylix
    ];

    options.sys.home.stylix = {
      enable = lib.mkEnableOption "toggle custom stylix setup";
    };

    config = lib.mkIf cfg.enable {
      stylix.enable = true;
      stylix.autoEnable = false;
      stylix.polarity = "dark";
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      stylix.cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      stylix.fonts = {
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };

        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };

        monospace = {
          package = pkgs.source-code-pro;
          name = "Source Code Pro";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };

      # manual enabled stylix submodules that don't present in my other modules
      stylix.targets = {
        gtk.enable = true;
      };
    };
  };
}
