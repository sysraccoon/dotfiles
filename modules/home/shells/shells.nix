rec {
  default = {
    imports = [
      zsh
    ];
  };

  zsh = import ./zsh/zsh.nix;
}
