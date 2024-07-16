# ~/~ begin <<notes/nvim.md#nvim-nix>>[init]
{
  lib,
  pkgs,
  config,
  impurity,
  ...
}: let
  cfg = config.sys.home.editors.nvim;
in {
  options = {
    sys.home.editors.nvim = {
      enable = lib.mkEnableOption "custom neovim setup";
    };
  };

  config = lib.mkIf cfg.enable {
    # ~/~ begin <<notes/nvim.md#nvim-nix-config>>[init]
    programs.neovim = {
      enable = true;

      # ~/~ begin <<notes/nvim.md#nvim-nix-python>>[init]
      withPython3 = true;
      extraPython3Packages = ps:
        with ps; [
          pynvim
        ];
      # ~/~ end
      # ~/~ begin <<notes/nvim.md#nvim-nix-extra-packages>>[init]
      extraPackages = with pkgs; [
        # python language server (installed as separate package,
        # because extraPython3Packages not provide bin/ folder to editor $PATH variable)
        python312Packages.jedi-language-server
        luaPackages.luarocks # package manager for lua
        tree-sitter # is optional, but allow use :TSInstallFromGrammar command
        nil # nix language server
        cargo # need for nil language server builded through mason
        stylua # lua formatter
        alejandra # nix formatter
        prettierd # markdown formatter (supported more languages, but currently I don't use them)
      ];
      # ~/~ end
    };
    # ~/~ end
    # ~/~ begin <<notes/nvim.md#nvim-nix-config>>[1]
    programs.neovim.extraLuaConfig = ''
      require("sysraccoon")
    '';

    xdg.configFile = {
      "nvim/lua".source = impurity.link ./lua;
      "nvim/snippets".source = impurity.link ./snippets;
    };
    # ~/~ end
    # ~/~ begin <<notes/nvim.md#nvim-nix-config>>[2]
    stylix.targets.vim.enable = false;
    # ~/~ end
  };
}
# ~/~ end

