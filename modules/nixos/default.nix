rec {
  default = {
    imports = [
      i18n
      nix
    ];
  };

  i18n = import ./i18n.nix;
  nix = import ./nix.nix;
}