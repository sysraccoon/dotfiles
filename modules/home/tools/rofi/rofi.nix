{
  config,
  lib,
  pkgs,
  impurity,
  ...
}: let
  cfg = config.sys.home.tools.rofi;
in {
  options.sys.home.tools.rofi = {
    enable = lib.mkEnableOption "toggle custom rofi setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-wayland
    ];

    xdg.configFile."rofi/config.rasi".text = ''
      /* @theme reset all previusly initialized style parameters */
      @theme "${impurity.link ./theme.rasi}"
    '';
  };
}
