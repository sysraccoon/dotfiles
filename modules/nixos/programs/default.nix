rec {
  default = {
    imports = [
      syncthing
      wireshark
    ];
  };

  syncthing = import ./syncthing.nix;
  wireshark = import ./wireshark.nix;
}