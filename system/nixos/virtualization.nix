{ config, pkgs, ... }:

{
  boot.kernelModules = [ "kvm-amd" ];

  virtualisation.libvirtd.enable = true;

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    qemu
    qemu_kvm
    virt-manager
  ];

  users.users.raccoon.extraGroups = [
    "libvirtd"
  ];
}
