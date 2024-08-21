{...}: {
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    # sddm.enable = true;
  };

  services.xserver.enable = true;
  services.xserver.desktopManager = {
    xterm.enable = false;
    xfce.enable = true;
  };

  # services.xserver.displayManager.gdm.enable = true;
  programs.dconf.enable = true;

  services.journald.extraConfig = "SystemMaxUse=1G";

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire = {
      "10-null-sink" = {
        "context.objects" = [
          {
            "factory" = "adapter";
            "args" = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "virtual-obs-sink";
              "media.class" = "Audio/Duplex";
              "audio.position" = "[ FL FR ]";
              "monitor.channel-volumes" = true;
              "monitor.passthrough" = true;
              "adapter.auto-port-config" = {
                "mode" = "dsp";
                "monitor" = "true";
                "position" = "preserve";
              };
            };
          }
        ];
      };
    };
  };

  services.geoclue2 = {
    enable = true;
  };
}
