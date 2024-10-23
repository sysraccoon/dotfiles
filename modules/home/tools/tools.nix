rec {
  default = {
    imports = [
      rofi
      waybar
      tmux
      zathura
      obsidian
      kando
    ];
  };

  rofi = import ./rofi/rofi.nix;
  waybar = import ./waybar/waybar.nix;
  tmux = import ./tmux/tmux.nix;
  zathura = import ./zathura/zathura.nix;
  obsidian = import ./obsidian/obsidian.nix;
  kando = import ./kando/kando.nix;
}
