{
  nixosModules.default = {
    config,
    lib,
    ...
  }: let
    cfg = config.sys.nixos.keyboard;
  in {
    imports = [
      ./recurva/recurva.nix
      ./kanata/kanata.nix
    ];

    options.sys.nixos.keyboard = {
      enable = lib.mkEnableOption "toggle custom keyboard setup";
    };

    config = lib.mkIf cfg.enable {
      sys.nixos.keyboard.recurva.enable = true;
      sys.nixos.keyboard.kanata.enable = true;

      console.useXkbConfig = true;

      services.xserver.xkb = {
        layout = "us,recurva,ru";
        variant = "dvorak,,";
        options = "terminate:ctrl_alt_bksp";
      };
    };
  };

  homeManagerModules.default = {
    config,
    lib,
    ...
  }: let
    cfg = config.sys.home.keyboard;
  in {
    imports = [
      ./fcitx5/fcitx5.nix
    ];

    options.sys.home.keyboard = {
      enable = lib.mkEnableOption "toggle custom keyboard setup";
    };

    config = lib.mkIf cfg.enable {
      sys.home.keyboard.fcitx5.enable = true;
    };
  };
}
