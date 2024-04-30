{ config, pkgs, ... }:

{
  networking.networkmanager.enable = true;
  networking.dhcpcd.wait = "background";
  networking.dhcpcd.extraConfig = "noarp";

  # firewall configuration
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    8384 22000 # syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    22000 21027 # syncthing
  ];

  # Disable IPv6
  # networking.enableIPv6 = false;
  # boot.kernelParams = ["ipv6.disable=1"];
  networking.enableIPv6 = true;
}
