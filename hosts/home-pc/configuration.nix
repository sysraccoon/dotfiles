{bundles, ...}: {
  imports = [
    bundles.general.nixosModules.default
    ../general/configuration.nix
    ./hardware-configuration.nix
    ./machine-specific.nix
    ./impermanence.nix
  ];

  system.stateVersion = "22.11";
  networking.hostName = "home-pc";

  sys.nixos.desktops.hyprland-desktop = {
    enable = true;
    isDefaultDesktop = true;
  };

  sys.nixos.programs = {
    syncthing.enable = true;
    wireshark.enable = true;
    caps2esc.enable = true;
  };

  # sys.nixos.virtualization.enable = true;
}
