{ config, pkgs, lib, host-profile, overlays, ... }:

{

  imports = [
    ../../../general/configs/nixpkgs/home.nix
    ./hyprland.nix
    ./firefox.nix
    ./vscodium.nix
    ./emacs.nix
    ./plasma.nix
    # ./desktop.nix
  ];

  home.stateVersion = "22.11";

  home.username = "raccoon";
  home.homeDirectory = "/home/raccoon";

  home.packages = with pkgs; [
    # cli
    xdragon
    texlive.combined.scheme-full
    ibus
    ffmpeg
    openvpn
    fping
    nmap
    psmisc

    # VM
    vagrant
    qemu
    virt-manager
    wineWowPackages.stable
    spice
    virtio-win

    ## general
    zathura
    discord
    tdesktop
    libreoffice
    obs-studio
    gnome.gnome-sound-recorder
    mpv
    rofi-wayland
    cinnamon.nemo
    calibre
    qutebrowser
    tor-browser-bundle-bin
    rtorrent
    gnome-solanum
    qbittorrent
    pavucontrol
    emote
    gparted
    google-chrome

    # knowledge management
    obsidian
    logseq
    zotero

    # dev/re
    jetbrains.pycharm-community
    jetbrains.idea-community
    ghidra
    frida-tools
    android-tools
    android-studio
    apktool
    lldb_18
    gdbgui
    iaito
    wireshark

    # terminals
    kitty
    alacritty
    xterm

    ## X11
    feh
    flameshot
    peek
    xsecurelock

    ## wayland
    eww
    wofi
    cliphist
    swaybg
    wlr-randr
    grim
    slurp
    wl-clipboard
    hyprpaper
    hyprlock
    wlogout

    # audio
    alsa-tools
    alsa-utils
    pamixer
  ];

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = 1;
  };

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
      # "Shift_L" = "Super_L|bracketleft";
      # "Shift_R" = "Super_L|bracketright";
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
    anyrun.source = ../anyrun;
    wlogout.source = ../wlogout;

    "hypr/hyprpaper.conf".source = ../hypr/hyprpaper.conf;
    "hypr/hyprlock.conf".source = ../hypr/hyprlock.conf;
  };

  home.file."wallpaper.jpg".source = ../../resources/wallpapers/default.jpg;
}
