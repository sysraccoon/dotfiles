{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.sys.home.stylix;
in {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  options.sys.home.stylix = {
    enable = lib.mkEnableOption "toggle custom stylix setup";
  };

  config = lib.mkIf cfg.enable {
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
}
