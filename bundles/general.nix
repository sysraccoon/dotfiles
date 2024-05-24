let 
  combined = import ../modules/combined;
  common = import ../modules/common;
  home = import ../modules/home;
  nixos = import ../modules/nixos;
in {
  nixosModules.default = { lib, username, ... }: {
    imports = [
      common.default
      nixos.default
      combined.nixosModules.default
    ];

    sys.nixos.mainUser = {
      inherit username;
      enable = lib.mkDefault true;
      isSuperUser = lib.mkDefault true;
    };

    sys.nixos.i18n.enable = lib.mkDefault true;
    sys.nixos.nix.enable = lib.mkDefault true;

    sys.nixos.network = {
      enable = lib.mkDefault true;
      networkUsers = lib.mkDefault [ username ];
    };

    sys.nixos.programs.wireshark.wiresharkUsers = lib.mkDefault [ username ];
    sys.nixos.programs.syncthing.user = lib.mkDefault username;
  };

  homeManagerModules.default = {
    imports = [
      common.default
      home.default
      combined.homeManagerModules.default
    ];
  };
}