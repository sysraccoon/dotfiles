rec {
  default = {
    imports = [
      nvim
      vscodium
    ];
  };

  nvim = import ./nvim/nvim.nix;
  vscodium = import ./vscodium/vscodium.nix;
}