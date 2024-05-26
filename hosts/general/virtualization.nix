{
  config,
  pkgs,
  ...
}: {
  users.users.${config.sys.nixos.mainUser.username} = {
    extraGroups = ["docker" "kvm" "qemu-libvirtd" "libvirtd"];
  };

  boot.extraModprobeConfig = "options kvm_intel nested=1";
  boot.kernelModules = ["kvm-intel"];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
    spiceUSBRedirection.enable = true;
    docker.enable = true;
    docker.storageDriver = "btrfs";
  };
}
