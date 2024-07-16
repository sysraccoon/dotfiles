rec {
  default = {
    imports = [
      browsers.default
      editors.default
      terminals.default
      tools.default
      shells.default
    ];
  };

  browsers = import ./browsers/browsers.nix;
  editors = import ./editors/editors.nix;
  terminals = import ./terminals/terminals.nix;
  tools = import ./tools/tools.nix;
  shells = import ./shells/shells.nix;
}
