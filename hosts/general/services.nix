{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    # sddm.enable = true;
  };
  services.displayManager.defaultSession = "hyprland";

  services.xserver.windowManager.awesome = {
    enable = true;
    luaModules = with pkgs.luaPackages; [
      luarocks
    ];
  };

  services.xserver.windowManager.qtile.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager = {
    xterm.enable = false;
    xfce.enable = true;
  };
  services.dbus.packages = [ pkgs.libsForQt5.kglobalaccel ];
  environment.systemPackages = with pkgs; [
    nordic
    zafiro-icons
    plasma5Packages.bismuth

    waybar
    hyprpaper

  ];

  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;

  programs.hyprland.enable = true;

  # enable cups and open 631 tcp port
  # services.printing.enable = true;

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

  services.syncthing = {
    enable = true;
    user = "raccoon";
    configDir = "/home/raccoon/.config/syncthing";
    dataDir = "/home/raccoon/.config/syncthing/db";
  };
}
