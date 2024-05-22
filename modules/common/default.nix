rec {
  default = {
    imports = [
      impurity
    ];
  };

  impurity = import ./impurity.nix;
}