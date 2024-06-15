let
  keyboard = import ./keyboard/keyboard.nix;
  desktops = import ./desktops/desktops.nix;
in {
  nixosModules.default = {
    imports = [
      keyboard.nixosModules.default
      desktops.nixosModules.default
    ];
  };

  homeManagerModules.default = {
    imports = [
      keyboard.homeManagerModules.default
      desktops.homeManagerModules.default
    ];
  };

  nixosModules.keyboard = keyboard.nixosModules.default;
  homeManagerModules.keyboard = keyboard.homeManagerModules.default;

  nixosModules.desktops = desktops.nixosModules.default;
  homeManagerModules.desktops = desktops.homeManagerModules.default;
}
