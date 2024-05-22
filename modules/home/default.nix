rec {
  default = {
    imports = [
      browsers.default
      editors.default
      terminals.default
    ];
  };

  browsers = import ./browsers/browsers.nix;
  editors = import ./editors/editors.nix;
  terminals = import ./terminals/terminals.nix;
}