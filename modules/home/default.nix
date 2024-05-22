rec {
  default = {
    imports = [
      browsers.default
      editors.default
    ];
  };

  browsers = import ./browsers/browsers.nix;
  editors = import ./editors/editors.nix;
}