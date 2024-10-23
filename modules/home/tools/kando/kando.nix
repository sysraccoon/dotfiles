{
  config,
  pkgs,
  lib,
  impurity,
  ...
}: let
  cfg = config.sys.home.tools.kando;
in {
  options.sys.home.tools.kando = {
    enable = lib.mkEnableOption "toggle custom kando setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.kando
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "kando"
      ];
      windowrule = [
        "noblur, kando"
        "opaque, kando"
        "size 100% 100%, kando"
        "noborder, kando"
        "noanim, kando"
        "float, kando"
        "pin, kando"
      ];
    };
  };
}
