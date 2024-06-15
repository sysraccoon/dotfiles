{
  config,
  lib,
  ...
}: let
  cfg = config.sys.home.browsers.chromium;
in {
  options.sys.home.browsers.chromium = {
    enable = lib.mkEnableOption "toggle custom chromium setup";
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      commandLineArgs = [
        "--disable-new-avatar-menu"
        "--high-dpi-support=1"
        "--force-device-scale-factor=1.5"
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
      ];
      extensions = [
        # vimium
        {id = "dbepggeogbaibhgnhhndojpepiihcmeb";}
        # adblock
        {id = "cfhdojbkjhnklbpkdaibdccddilifddb";}
      ];
    };
  };
}
