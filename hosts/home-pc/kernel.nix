{ config, pkgs, lib, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.nvidia.modesetting.enable = true;
}
