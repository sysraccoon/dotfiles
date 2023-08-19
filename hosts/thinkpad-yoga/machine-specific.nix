{ config, pkgs, ... }:

{
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

  # Intel GPU Driver
  services.xserver = {
    videoDrivers = [ "intel" ];
    deviceSection = ''
      Option "DRI" "3"
      Option "TearFree" "true"
    '';
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
