{ lib, config, impurity, ... }:
let
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
      extraPython3Packages = (ps: with ps; [
        jedi
        pynvim
      ]);
    };

    xdg.configFile.nvim.source = impurity.link ./.;
  };
}