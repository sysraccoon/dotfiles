{
  config,
  pkgs,
  lib,
  impurity,
  ...
}: let
  cfg = config.sys.home.tools.tmux;
in {
  options.sys.home.tools.tmux = {
    enable = lib.mkEnableOption "toggle custom tools.tmux setup";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      extraConfig = ''
        source-file ${impurity.link ./tmux.conf}
      '';
    };

    home.packages = with pkgs; [
      tmuxinator
    ];

    xdg.configFile = {
      "tmuxinator/dotfiles.yml".source = impurity.link ./layouts/dotfiles.yml;
    };

    stylix.targets.tmux.enable = true;
  };
}
