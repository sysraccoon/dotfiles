{
  overlay = final: prev: {
    tpm = import ../packages/tpm.nix {pkgs = final;};
    hy3-0-41-1 = final.callPackage ../packages/hy3-0-41-1.nix {};
  };
}
