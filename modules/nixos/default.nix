rec {
  default = {
    imports = [
      programs.default
      i18n
      network
      nix
      user
      virtualization
      recurva
    ];
  };

  programs = import ./programs;
  i18n = import ./i18n.nix;
  network = import ./network.nix;
  nix = import ./nix.nix;
  user = import ./user.nix;
  virtualization = import ./virtualization.nix;
  recurva = import ./recurva/recurva.nix;
}
