{
  config,
  lib,
  pkgs,
  impurity,
  ...
}: let
  cfg = config.sys.home.terminals.kitty;
in {
  options.sys.home.terminals.kitty = {
    enable = lib.mkEnableOption "enable custom kitty setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
    ];

    programs.kitty = {
      enable = true;
      extraConfig = ''

        include ${impurity.link ./kitty.conf}

      '';
    };

    stylix.targets.kitty.enable = true;
    stylix.targets.kitty.variant256Colors = true;
  };
}
