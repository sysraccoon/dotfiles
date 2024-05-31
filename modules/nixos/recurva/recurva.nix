{
  config,
  lib,
  ...
}: let
  cfg = config.sys.nixos.layouts.recurva;
in {
  options.sys.nixos.layouts.recurva = {
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
