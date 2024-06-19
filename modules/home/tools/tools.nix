rec {
  default = {
    imports = [
      rofi
      waybar
      tmux
      zathura
      obsidian
    ];
  };

  rofi = import ./rofi/rofi.nix;
  waybar = import ./waybar/waybar.nix;
  tmux = import ./tmux/tmux.nix;
  zathura = import ./zathura/zathura.nix;
  obsidian = import ./obsidian/obsidian.nix;
}
