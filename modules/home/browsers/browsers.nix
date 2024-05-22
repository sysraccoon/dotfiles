rec {
  default = {
    imports = [
      firefox
    ];
  };

  firefox = import ./firefox/firefox.nix;
}