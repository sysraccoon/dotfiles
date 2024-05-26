rec {
  default = {
    imports = [
      rofi
    ];
  };

  rofi = import ./rofi/rofi.nix;
}
