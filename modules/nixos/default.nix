rec {
  default = {
    imports = [
      programs.default
      i18n
      network
      nix
    ];
  };

  programs = import ./programs;
  i18n = import ./i18n.nix;
  nix = import ./nix.nix;
  network = import ./network.nix;
}