{
  config,
  lib,
  ...
}: let
  cfg = config.sys.nixos.keyboard.recurva;
in {
  options.sys.nixos.keyboard.recurva = {
    enable = lib.mkEnableOption "enable recurva layout";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.xkb.extraLayouts.recurva = {
      description = "Recurva english layout";
      languages = ["eng"];
      symbolsFile = ./recurva;
    };
  };
}
