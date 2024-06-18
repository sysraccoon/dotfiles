{
  pkgs,
  ctx,
  inputs,
  bundles,
  impurity,
  sysUtils,
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
    xdragon
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
    virt-manager
    wineWowPackages.stable
    spice
    virtio-win

    ## general
    zathura
    discord
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

    # knowledge management
    obsidian
    (sysUtils.patchDesktop {
      pkg = obsidian;
      appName = "obsidian";
      from = [
        "Exec=obsidian %u"
      ];
      to = [
        "Exec=obsidian --enable-wayland-ime %u"
      ];
    })

    logseq

    # dev/re
    jetbrains-toolbox
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

    ## X11
    feh
    flameshot
    peek
    xsecurelock
    xcur2png

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

  sys.home.terminals.alacritty.enable = true;
  sys.home.terminals.kitty.enable = true;

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
      "x-scheme-handler/tg" = ["userapp-Telegram Desktop-08XUJ1.desktop"];
      "inode/directory" = ["org.kde.dolphin.desktop"];
    };
  };

  xdg.dataFile.fonts.source = impurity.link ../../resources/fonts;

  xdg.configFile = {
    "dunst/dunstrc".source = impurity.link ../dunst/dunstrc;
  };

  # services.gammastep = {
  #   enable = true;
  #   provider = "geoclue2";
  #   duskTime = "18:35-20:15";
  #   dawnTime = "6:00-7:45";
  # };
}
