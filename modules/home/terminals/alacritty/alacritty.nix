{
  config,
  lib,
  pkgs,
  impurity,
  ...
}: let
  cfg = config.sys.home.terminals.alacritty;
in {
  options.sys.home.terminals.alacritty = {
    enable = lib.mkEnableOption "enable custom alacritty setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      alacritty
    ];

    xdg.configFile = {
      "alacritty/alacritty.yml".source = impurity.link ./alacritty.yml;
    };
  };
}
