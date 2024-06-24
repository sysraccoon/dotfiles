rec {
  nixosModules.default = {
    imports = [
      nixosModules.impurity
      nixosModules.stylix
    ];
  };

  homeManagerModules.default = {
    imports = [
      homeManagerModules.impurity
      homeManagerModules.stylix
      homeManagerModules.sysUtils
    ];
  };

  nixosModules.impurity = import ./impurity.nix;
  nixosModules.stylix = (import ./stylix.nix).nixosModules.default;

  homeManagerModules.impurity = import ./impurity.nix;
  homeManagerModules.stylix = (import ./stylix.nix).homeManagerModules.default;
  homeManagerModules.sysUtils = import ./sys-utils.nix;
}
