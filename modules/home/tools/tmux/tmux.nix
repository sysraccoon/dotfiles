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
      tpm # tpm packed by myself, see $DOTFILES_DIR/packages/tpm.nix
    ];

    home.file = {
      ".tmux/plugins/tpm".source = "${pkgs.tpm}/share/tpm";
    };

    xdg.configFile = {
      "tmuxinator/dotfiles.yml".source = impurity.link ./layouts/dotfiles.yml;
    };

    stylix.targets.tmux.enable = true;
  };
}
