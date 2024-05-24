{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    # sddm.enable = true;
  };

  services.xserver.desktopManager = {
    xterm.enable = false;
    xfce.enable = true;
  };

  # services.xserver.displayManager.gdm.enable = true;
  programs.dconf.enable = true;

  services.journald.extraConfig = "SystemMaxUse=1G";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
