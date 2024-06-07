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
        hhkb = {
          devices = [
            "/dev/input/by-id/usb-Topre_Corporation_HHKB_Professional-event-kbd"
          ];
          config = builtins.readFile ./hhkb.kbd;
        };
      };
    };
  };
}