# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/97a4f5d4-dfa7-43b1-b6ee-dce71b6beaac";
    fsType = "btrfs";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/6aa10923-0ec1-4138-8386-19f158d6a0af";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/55674003-b34d-4932-b18a-71f852b78ca1";
    fsType = "btrfs";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/506E-F36A";
    fsType = "vfat";
  };

  fileSystems."/store" = {
    device = "/dev/disk/by-uuid/8258c128-af21-4997-a5ab-3f8ba2a99ac6";
    fsType = "ext4";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/3534089d-8146-4349-adbe-95d3a4f0776d";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s20u2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
