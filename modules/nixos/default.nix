rec {
  default = {
    imports = [
      i18n
    ];
  };

  i18n = import ./i18n.nix;
}