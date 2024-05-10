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

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
}
