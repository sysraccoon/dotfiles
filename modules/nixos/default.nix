rec {
  default = {
    imports = [
      i18n
      nix
      syncthing
    ];
  };

  i18n = import ./i18n.nix;
  nix = import ./nix.nix;
  syncthing = import ./syncthing.nix;
}