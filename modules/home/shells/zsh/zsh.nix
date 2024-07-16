# ~/~ begin <<notes/zsh.md#modules/home/shells/zsh/zsh.nix>>[init]
{
  config,
  pkgs,
  lib,
  impurity,
  ...
}: let
  cfg = config.sys.home.shells.zsh;
in {
  options.sys.home.shells.zsh = {
    enable = lib.mkEnableOption "toggle custom zsh setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh
      # ~/~ begin <<notes/zsh.md#zsh-packages>>[init]
      starship
      # ~/~ end
      # ~/~ begin <<notes/zsh.md#zsh-packages>>[1]
      zsh-fzf-tab
      # ~/~ end
      # ~/~ begin <<notes/zsh.md#zsh-packages>>[2]
      direnv
      nix-direnv
      nix-direnv-flakes
      # ~/~ end
      # ~/~ begin <<notes/zsh.md#zsh-packages>>[3]
      zsh-syntax-highlighting
      # ~/~ end
      # ~/~ begin <<notes/zsh.md#zsh-packages>>[4]
      eza
      ripgrep
      zoxide
      bat
      btop
      # ~/~ end
      # ~/~ begin <<notes/zsh.md#zsh-packages>>[5]
      git
      # ~/~ end
    ];

    xdg.configFile."starship/starship.toml".source = impurity.link ./starship.toml;
    xdg.configFile."zsh".source = impurity.link ./zsh;
    home.file.".zshrc".source = pkgs.writeText ".zshrc" ''
      source "''${XDG_CONFIG_DIR:-$HOME/.config}/zsh/config.zsh"
    '';
  };
}
# ~/~ end

