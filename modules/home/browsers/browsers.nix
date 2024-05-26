rec {
  default = {
    imports = [
      firefox
      qutebrowser
    ];
  };

  firefox = import ./firefox/firefox.nix;
  qutebrowser = import ./qutebrowser/qutebrowser.nix;
}
