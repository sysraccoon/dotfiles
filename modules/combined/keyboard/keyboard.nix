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
        layout = "us,recurva,ru,cn";
        variant = "dvorak,,";
        options = "grp:shifts_toggle,ctrl:nocaps,altwin:swap_lalt_lwin,terminate:ctrl_alt_bksp,compose:ralt";
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
