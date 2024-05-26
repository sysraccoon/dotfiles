rec {
  nixosModules.default = {
    imports = [
      nixosModules.impurity
    ];
  };

  homeManagerModules.default = {
    imports = [
      homeManagerModules.impurity
      homeManagerModules.stylix
    ];
  };

  nixosModules.impurity = import ./impurity.nix;

  homeManagerModules.impurity = import ./impurity.nix;
  homeManagerModules.stylix = import ./stylix.nix;
}
