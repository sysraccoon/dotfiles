let 
  combined = import ../modules/combined;
  common = import ../modules/common;
  home = import ../modules/home;
  nixos = import ../modules/nixos;
in {
  nixosModules.default = { lib, ... }: {
    imports = [
      common.default
      nixos.default
      combined.nixosModules.default
    ];

    sys.nixos.i18n.enable = lib.mkDefault true;
    sys.nixos.nix.enable = lib.mkDefault true;
  };

  homeManagerModules.default = {
    imports = [
      common.default
      home.default
      combined.homeManagerModules.default
    ];
  };
}