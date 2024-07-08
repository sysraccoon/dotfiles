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
    programs.neovim = {
      enable = true;
      withPython3 = true;
      extraPython3Packages = ps:
        with ps; [
          pynvim
        ];

      extraPackages = with pkgs; [
        python312Packages.jedi-language-server
      ];

      extraLuaConfig = ''
        require("sysraccoon")
      '';
    };

    xdg.configFile = {
      "nvim/snippets".source = impurity.link ./snippets;
      "nvim/lua".source = impurity.link ./lua;
    };

    stylix.targets.vim.enable = false;
  };
}
