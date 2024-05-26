let
  core = import ../modules/core;
  combined = import ../modules/combined;
  home = import ../modules/home;
  nixos = import ../modules/nixos;
in {
  nixosModules.default = {
    lib,
    username,
    ...
  }: {
    imports = [
      core.nixosModules.default
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
      networkUsers = lib.mkDefault [username];
    };

    sys.nixos.virtualization.virtualizationUsers = lib.mkDefault [username];

    sys.nixos.programs.wireshark.wiresharkUsers = lib.mkDefault [username];
    sys.nixos.programs.syncthing.user = lib.mkDefault username;
  };

  homeManagerModules.default = {lib, ...}: {
    imports = [
      core.homeManagerModules.default
      home.default
      combined.homeManagerModules.default
    ];

    sys.home.stylix.enable = lib.mkDefault true;
  };
}
