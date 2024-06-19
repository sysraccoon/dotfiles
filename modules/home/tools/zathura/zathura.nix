{
  config,
  pkgs,
  lib,
  impurity,
  ...
}: let
  cfg = config.sys.home.tools.zathura;
in {
  options.sys.home.tools.zathura = {
    enable = lib.mkEnableOption "toggle custom zathura setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zathura
    ];

    xdg.configFile = {
      "zathura/zathurarc".source = impurity.link ./zathurarc;
      "zathura/catppuccin-mocha".source = impurity.link ./catppuccin-mocha;
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
  };
}
