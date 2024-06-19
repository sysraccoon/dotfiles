{
  config,
  pkgs,
  lib,
  sysUtils,
  ...
}: let
  cfg = config.sys.home.tools.obsidian;
in {
  options.sys.home.tools.obsidian = {
    enable = lib.mkEnableOption "toggle custom obsidian setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      obsidian
      (sysUtils.patchDesktop {
        pkg = obsidian;
        appName = "obsidian";
        from = [
          "Exec=obsidian %u"
        ];
        to = [
          "Exec=obsidian --enable-wayland-ime %u"
        ];
      })
    ];
  };
}
