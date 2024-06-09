rec {
  default = {
    imports = [
      chromium
      firefox
      qutebrowser
    ];
  };

  chromium = import ./chromium/chromium.nix;
  firefox = import ./firefox/firefox.nix;
  qutebrowser = import ./qutebrowser/qutebrowser.nix;
}
