rec {
  default = {
    imports = [
      alacritty
      kitty
    ];
  };

  alacritty = import alacritty/alacritty.nix;
  kitty = import kitty/kitty.nix;
}