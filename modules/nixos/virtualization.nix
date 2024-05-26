{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.sys.nixos.virtualization;
in {
  options.sys.nixos.virtualization = {
    enable = lib.mkEnableOption "toggle custom virtualization setup";
    virtualizationUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "members of virtualization related groups";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = builtins.listToAttrs (
      builtins.map (user: {
        name = user;
        value = {
          extraGroups = ["docker" "kvm" "qemu-libvirtd" "libvirtd"];
        };
      })
      cfg.virtualizationUsers
    );

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
  };
}
