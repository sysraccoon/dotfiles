{
  pkgs,
  inputs,
  bundles,
  impurity,
  sysUtils,
  ctx,
  ...
}: {
  imports = [
    bundles.general.homeManagerModules.default
    ../../../general/configs/nixpkgs/home.nix
    ./emacs.nix
  ];

  home.stateVersion = "22.11";

  home.username = ctx.username;
  home.homeDirectory = "/home/${ctx.username}";

  home.packages = with pkgs; [
    # nix specific
    inputs.nix-alien.packages.${ctx.system}.nix-alien
    manix
    nixpkgs-fmt

    # cli
    argbash
    texlive.combined.scheme-full
    ibus
    ffmpeg
    openvpn
    fping
    nmap
    psmisc
    usbutils

    # VM
    vagrant
    qemu
    wineWowPackages.stable
    spice
    virtio-win

    ## general
    discord
    webcord
    tdesktop
    libreoffice
    gnome.gnome-sound-recorder
    mpv
    vlc
    cinnamon.nemo
    calibre
    tor-browser-bundle-bin
    rtorrent
    gnome-solanum
    qbittorrent
    pavucontrol
    emote
    gparted
    google-chrome
    asciinema
    feh
    unetbootin
    vial
    qmk

    # dev/re
    jetbrains.pycharm-community
    jetbrains.idea-community
    ghidra
    frida-tools
    lldb_18
    gdbgui
    iaito
    twine
    burpsuite

    # android
    scrcpy
    android-studio
    android-tools
    apktool
    inputs.adb-install-cert.packages.${ctx.system}.adb-install-cert
    apksigner

    # terminals
    xterm

    # audio
    alsa-tools
    alsa-utils
    pamixer
    audacity
    zam-plugins
  ];

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
      wlrobs
    ];
  };

  sys.home.browsers.firefox.enable = true;
  sys.home.browsers.chromium.enable = true;

  sys.home.desktops.hyprland-desktop = {
    enable = true;
    extraConfig = ''
      source = ${impurity.link ../hypr/hyprland.conf}
    '';
  };
  sys.home.tools.waybar.config = ../waybar/config;

  sys.home.terminals.alacritty.enable = true;
  sys.home.terminals.kitty.enable = true;
  sys.home.tools.obsidian.enable = true;

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/tg" = ["userapp-Telegram Desktop-08XUJ1.desktop"];
    };
  };

  xdg.dataFile.fonts.source = impurity.link ../../resources/fonts;

  xdg.configFile = {
    "dunst/dunstrc".source = impurity.link ../dunst/dunstrc;
  };
}
