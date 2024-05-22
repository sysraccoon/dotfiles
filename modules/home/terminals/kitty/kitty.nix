{ config, lib, pkgs, impurity, ... }:
let 
  cfg = config.sys.home.terminals.kitty;
in {
  options.sys.home.terminals.kitty = {
    enable = lib.mkEnableOption "enable custom kitty setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
    ];

    xdg.configFile = {
      "kitty/kitty.conf".source = impurity.link ./kitty.conf;
    };
  };
}