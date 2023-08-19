{ config, pkgs, lib, host-profile, overlays, ... }:

{

  imports = [
    ../../../general/configs/nixpkgs/home.nix
    ./hyprland.nix
    ./firefox.nix
    ./vscodium.nix
    ./emacs.nix
    ./gnome.nix
  ];

  home.stateVersion = "22.11";

  home.username = "raccoon";
  home.homeDirectory = "/home/raccoon";

  home.packages = with pkgs; [
    # cli
    xdragon
    vagrant
    qemu
    texlive.combined.scheme-full

    ## general
    zathura
    discord
    tdesktop
    libreoffice
    obs-studio
    mpv
    rofi
    cinnamon.nemo
    calibre
    qutebrowser
    tor-browser-bundle-bin

    # dev/re
    jetbrains.pycharm-community
    jetbrains.idea-community
    ghidra

    # terminals
    kitty
    alacritty
    xterm

    ## X11
    feh
    flameshot
    xsecurelock

    ## wayland
    eww-wayland
    wofi
    cliphist
    swaybg

    # audio
    alsa-tools
    alsa-utils
    pamixer

    # fonts
    ubuntu_font_family
    source-code-pro
    babelstone-han
    noto-fonts-emoji
    symbola
    nanum
  ];

  xsession.enable = true;

  services.picom = {
    enable = true;
    vSync = true;
    backend = "xr_glx_hybrid";
    settings = {
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
      unredir-if-possible = true;
      xrender-sync-fence = true;
    };
  };

  services.random-background = {
    enable = true;
    imageDirectory = builtins.toString ../../resources/wallpapers;
    display = "fill";
  };

  services.unclutter = {
    enable = true;
    timeout = 10;
  };

  services.dunst = {
    enable = true;
  };

  services.xcape = {
    enable = true;
    timeout = 200;
    mapExpression = {
      "Control_L" = "Escape";
      "Shift_L" = "Super_L|bracketleft";
      "Shift_R" = "Super_L|bracketright";
    };
  };

  services.flameshot.enable = true;

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
      "x-scheme-handler/tg" = ["userapp-Telegram Desktop-08XUJ1.desktop"];
      "inode/directory" = ["org.kde.dolphin.desktop"];
    };
  };


  xdg.dataFile.fonts.source = ../../resources/fonts;

  xdg.configFile = {
    qtile.source = ../qtile;
    alacritty.source = ../alacritty;
    qutebrowser.source = ../qutebrowser;
    rofi.source = ../rofi;
    dunst.source = ../dunst;
    kitty.source = ../kitty;
    waybar.source = ../waybar;
    eww.source = ../eww;
  };
}
