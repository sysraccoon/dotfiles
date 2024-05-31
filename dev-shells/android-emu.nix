{pkgs ? import <nixpkgs> {}, ...}: let
  fhs = pkgs.buildFHSUserEnv {
    name = "android-emu";
    targetPkgs = pkgs:
      with pkgs; [
        # XORG related stuff
        xorg.libX11
        xorg.libxcb
        xorg.libXext
        xorg.libXi
        xorg.setxkbmap
        xorg.xcbutilwm
        xorg.xcbutilrenderutil
        xorg.xcbutilkeysyms
        xorg.xcbutilimage
        xorg.xcbutilcursor
        xorg.libICE
        xorg.libSM
        xorg.libxkbfile
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXfixes
        xorg.libXrender
        libxkbcommon

        # GTK related stuff
        gtk2
        glib
        gnome2.gnome_vfs
        gnome2.GConf

        # Some other requirements
        libpulseaudio
        libpng
        zlib
        nspr
        expat
        libdrm
        libbsd
        file
        glxinfo
        pciutils
        alsa-lib
        dbus
        libuuid
        libGL
        nss_latest
      ];
    profile = ''
      export QT_QPA_PLATFORM=xcb
      export QT_XKB_CONFIG_ROOT=${pkgs.xorg.setxkbmap}/share/X11/xkb
      export ANDROID_EMULATOR_USE_SYSTEM_LIBS=1
    '';
    runScript = "zsh";
  };
in
  fhs.env
