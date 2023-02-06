{ config, pkgs, ... }:

{
  imports = [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Nvidia GPU Driver
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
}
