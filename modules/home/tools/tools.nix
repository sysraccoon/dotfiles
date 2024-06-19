rec {
  default = {
    imports = [
      rofi
      waybar
      tmux
    ];
  };

  rofi = import ./rofi/rofi.nix;
  waybar = import ./waybar/waybar.nix;
  tmux = import ./tmux/tmux.nix;
}
