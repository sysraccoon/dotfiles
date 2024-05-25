rec {
  default = {
    imports = [
      caps2esc
      syncthing
      wireshark
    ];
  };

  caps2esc = import ./caps2esc.nix;
  syncthing = import ./syncthing.nix;
  wireshark = import ./wireshark.nix;
}