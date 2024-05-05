{ config, pkgs, ... }:

{
  virtualisation.lxd.enable = true;

  users.users.raccoon = {
    extraGroups = [ "lxd" "qemu-libvirtd" "libvirtd" ];
  };

  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.kernelModules = [ "kvm-intel" ];

  boot.loader.grub = {
    extraConfig = ''
      GRUB_CMDLINE_LINUX="nvidia-drm.modeset=1"
    '';
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
}
