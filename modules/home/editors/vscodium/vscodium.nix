{
  lib,
  pkgs,
  config,
  impurity,
  inputs,
  ...
}: let
  cfg = config.sys.home.editors.vscodium;
  nix-vscode-extensions = inputs.nix-vscode-extensions;
  extensions = nix-vscode-extensions.extensions.${pkgs.system};
in {
  options = {
    sys.home.editors.vscodium = {
      enable = lib.mkEnableOption "custom vscodium setup";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode-with-extensions.override {
        vscode = pkgs.vscodium;
        vscodeExtensions = with extensions.vscode-marketplace; [
          # general
          vscodevim.vim
          akamud.vscode-theme-onedark
          naumovs.color-highlight

          # for some reason, this theme don't available from vscode marketplace
          extensions.open-vsx.jolaleye.horizon-theme-vscode

          # python
          ms-python.python
          ms-python.isort

          # js/ts
          ms-vscode.vscode-typescript-next
          dsznajder.es7-react-js-snippets

          # rust
          rust-lang.rust-analyzer
          tamasfe.even-better-toml

          # haskell
          haskell.haskell
          justusadam.language-haskell

          # nix
          jnoortheen.nix-ide
          arrterian.nix-env-selector
        ];
      };
    };

    # stylix.targets.vscode.enable = true;

    xdg.configFile."VSCodium/User/settings.json".source = impurity.link ./settings.json;
    xdg.configFile."VSCodium/User/keybindings.json".source = impurity.link ./keybindings.json;
  };
}
