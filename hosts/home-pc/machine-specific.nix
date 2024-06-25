{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelModules = [
    "dm-mirror"
    "dm-snapshot"
    "v4l2loopback"
  ];

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";

    grub.enable = true;
    grub.efiSupport = true;
    grub.configurationLimit = 10;
    grub.device = "nodev";
    grub.useOSProber = true;
  };

  # systemd = {
  #   targets.network-online.wantedBy = pkgs.lib.mkForce []; # Normally ["multi-user.target"]
  #   services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce []; # Normally ["network-online.target"]
  # };

  # Optimize cpu usage
  powerManagement.cpuFreqGovernor = "performance";

  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };

  boot.initrd.kernelModules = ["amdgpu"];

  # droid cam setup
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  programs.adb.enable = true; # enable android proper data tethering
  users.groups.video = {
    members = [config.sys.nixos.mainUser.username];
  };

  services.fwupd.enable = true;

  services.udev.extraRules = ''
    # Google Pixel 5
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0660", GROUP="plugdev"
  '';

  users.groups.plugdev = {
    members = [config.sys.nixos.mainUser.username];
  };
}
