{ config, pkgs, ... }:

{
  # Basic QEMU-KVM setup
  boot.kernelModules = [
    "kvm-amd"
    "vfio-pci"
  ];

  boot.blacklistedKernelModules = [
    "nouveau"
  ];

  virtualisation.libvirtd.enable = true;

  users.users.raccoon.extraGroups = [
    "libvirtd"
  ];

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virt-manager
  ];

  # Basic VirtualBox setup

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "raccoon" ];

  # Networking

  networking.dhcpcd.denyInterfaces = [
    "br0@*"
  ];
  networking.interfaces.br0.useDHCP = false;
  networking.bridges = {
    "br0" = {
      interfaces = [ "enp5s0" ];
    };
  };
}
