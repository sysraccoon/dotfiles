{ config, pkgs, inputs, ... }:

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

  hardware.opengl.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];

  services.fwupd.enable = true;

  services.udev.extraRules = ''
    # Google Pixel 5
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0660", GROUP="plugdev"
  '';

  users.groups.plugdev = {
    members = [ "raccoon" ];
  };
}
