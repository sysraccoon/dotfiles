{ config, lib, pkgs, impurity, ... }:
let
  cfg = config.sys.home.browsers.qutebrowser;
in {
  options.sys.home.browsers.qutebrowser = {
    enable = lib.mkEnableOption "enable custom qutebrowser setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qutebrowser
    ];

    xdg.configFile = {
      qutebrowser.source = impurity.link ./.;
    };
  };
}