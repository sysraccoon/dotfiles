{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./kernel.nix
    ./services.nix
    ./packages.nix
  ];
}
