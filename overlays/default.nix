{
  nixpkgs-overlays = [
    (import ./interception-tools).overlay
    (import ./custom-packages.nix).overlay
  ];
}
