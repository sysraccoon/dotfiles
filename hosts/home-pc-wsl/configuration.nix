{
  bundles,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
    bundles.general.nixosModules.default
    ../general/configuration.nix
  ];

  system.stateVersion = "22.11";
  networking.hostName = "home-pc-wsl";

  wsl.enable = true;
  wsl.defaultUser = username;

  sys.nixos.keyboard.enable = false;
}
