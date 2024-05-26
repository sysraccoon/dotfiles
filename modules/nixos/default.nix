rec {
  default = {
    imports = [
      programs.default
      i18n
      network
      nix
      user
    ];
  };

  programs = import ./programs;
  i18n = import ./i18n.nix;
  network = import ./network.nix;
  nix = import ./nix.nix;
  user = import ./user.nix;
}
