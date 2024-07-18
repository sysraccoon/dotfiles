{
  config,
  lib,
  ...
}: let
  cfg = config.sys.nixos.keyboard.kanata;
in {
  options.sys.nixos.keyboard.kanata = {
    enable = lib.mkEnableOption "toggle custom kanata setup";
  };

  config = lib.mkIf cfg.enable {
    services.kanata = {
      enable = true;
      keyboards = {
        default.config = builtins.readFile ./default.kbd;
      };
    };
  };
}
