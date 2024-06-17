{
  config,
  lib,
  pkgs,
  impurity,
  ...
}: let
  cfg = config.sys.home.keyboard.fcitx5;
in {
  options.sys.home.keyboard.fcitx5 = {
    enable = lib.mkEnableOption "toggle custom fcitx5 setup";
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
        # fcitx5-rime
        fcitx5-gtk
      ];
    };

    xdg.configFile = {
      "fcitx5".source = impurity.link ./.;
    };
  };
}
