{ config, pkgs, ... }:

{
  imports = [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
  ];

  boot.kernelModules = [
    "dm-mirror"
    "dm-snapshot"
  ];

  # Bootloader.
  boot.loader = {
    # systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";

    grub.enable = true;
    grub.efiSupport = true;
    grub.configurationLimit = 10;
    grub.version = 2;
    grub.device = "nodev";
    grub.useOSProber = true;
  };

  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  };

  # Optimize cpu usage
  powerManagement.cpuFreqGovernor = "performance";

  hardware.enableRedistributableFirmware = true;

  # Nvidia GPU Driver
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.powerManagement.enable = true;
}
