{
  bundles,
  lib,
  ...
}: {
  imports = [
    bundles.general.nixosModules.default
    ../general/configuration.nix
    ./hardware-configuration.nix
    ./machine-specific.nix
  ];

  system.stateVersion = "22.11";
  networking.hostName = "thinkpad-yoga";

  sys.nixos.desktops.hyprland-desktop = {
    enable = true;
    isDefaultDesktop = true;
  };

  sys.nixos.virtualization.enable = true;

  sys.nixos.keyboard.kanata.enable = lib.mkForce false;
}
