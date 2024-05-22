let
  desktops = import ./desktops/desktops.nix;
in {
  nixosModules.default = {
    imports = [
      desktops.nixosModules.default
    ];
  };

  homeManagerModules.default = {
    imports = [
      desktops.homeManagerModules.default
    ];
  };

  nixosModules.desktops = desktops.nixosModules.default;
  homeManagerModules.desktops = desktops.homeManagerModules.default;
}
