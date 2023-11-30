{ config, pkgs, ... }:

{
  virtualisation.lxd.enable = true;

  users.users.raccoon = {
    extraGroups = [ "lxd" "qemu-libvirtd" "libvirtd" ];
  };

  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.kernelModules = [ "kvm-intel" ];

  virtualisation.libvirtd.enable = true;
}
