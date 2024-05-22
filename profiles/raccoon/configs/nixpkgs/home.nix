{ config, pkgs, lib, ctx, inputs, bundles, impurity, ... }:

{

  imports = [
    bundles.general.homeManagerModules.default
    ../../../general/configs/nixpkgs/home.nix
    ./emacs.nix
  ];

  home.stateVersion = "22.11";

  home.username = ctx.username;
  home.homeDirectory = "/home/${ctx.username}";

  home.packages = with pkgs; [
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
    inputs.nix-alien.packages.${ctx.system}.nix-alien
    apksigner

    # VM
    vagrant
    qemu
    virt-manager
    wineWowPackages.stable
    spice
    virtio-win
    jetbrains-toolbox

    ## general
    zathura
    discord
    tdesktop
    libreoffice
    obs-studio
    gnome.gnome-sound-recorder
    mpv
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
    asciinema

    # knowledge management
    obsidian
    logseq
    zotero

    # dev/re
    jetbrains.pycharm-community
    jetbrains.idea-community
    ghidra
    frida-tools
    lldb_18
    gdbgui
    iaito
    wireshark
    twine
    burpsuite

    # android
    scrcpy
    android-studio
    android-tools
    apktool
    inputs.adb-install-cert.packages.${ctx.system}.adb-install-cert

    # terminals
    kitty
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
  ];

  sys.home.browsers.firefox.enable = true;
  sys.home.desktops.hyprland-desktop = {
    enable = true;
    extraConfig = ''
      source = ${impurity.link ../hypr/hyprland-overrides.conf}
    '';
  };

  sys.home.terminals.alacritty.enable = true;
  sys.home.terminals.kitty.enable = true;

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

  xdg.dataFile.fonts.source = impurity.link ../../resources/fonts;

  xdg.configFile = {
    qutebrowser.source = impurity.link ../qutebrowser;
    "dunst/dunstrc".source = impurity.link ../dunst/dunstrc;
  };

  home.file.".background-image".source = impurity.link ../../resources/wallpapers/default.jpg;

  home.file.".icons/McMojava-X-cursors".source = ../../resources/icons/McMojava-X-cursors;
  home.file.".icons/McMojava-hypr-cursors".source = ../../resources/icons/McMojava-hypr-cursors;
}
