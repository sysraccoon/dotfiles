{
  nixosModules.default =
    { config, pkgs, lib, inputs, ... }:
    let
      cfg = config.sys.nixos.desktops.qtile-desktop;
    in {
      options.sys.nixos.desktops.qtile-desktop = {
        enable = lib.mkEnableOption "enable custom qtile setup";
        isDefaultDesktop = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "set qtile as default in display manager";
        };
      };

      config = lib.mkIf cfg.enable {
        services.xserver.enable = true;
        services.xserver.windowManager.qtile.enable = true;

        services.displayManager = lib.mkIf cfg.isDefaultDesktop {
          defaultSession = "qtile";
        };
      };
    };

  homeManagerModules.default =
    { config, pkgs, lib, impurity, inputs, ... }: 
    let
      cfg = config.sys.home.desktops.qtile-desktop;
    in {
      options.sys.home.desktops.qtile-desktop = {
        enable = lib.mkEnableOption "enable custom qtile setup";
      };

      config = lib.mkIf cfg.enable {
        xdg.configFile = {
          qtile.source = impurity.link ./.;
        };
      };
    };
}