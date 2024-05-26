rec {
  default = {
    imports = [
      rofi
      waybar
    ];
  };

  rofi = import ./rofi/rofi.nix;
  waybar = import ./waybar/waybar.nix;
}
