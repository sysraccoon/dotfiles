{ config, pkgs, lib, host-profile, overlays, ctx, impurity, inputs, ... }:

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
    scrcpy
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
    android-studio
    android-tools
    apktool
    inputs.adb-install-cert.packages.${ctx.system}.adb-install-cert

    # terminals
    kitty
    alacritty
    xterm

    ## X11
    feh
    flameshot
    peek
    xsecurelock
    xcur2png

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
    hyprcursor
    wlogout
    wlprop

    # audio
    alsa-tools
    alsa-utils
    pamixer

    # games
    osu-lazer-bin
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

  xdg.dataFile.fonts.source = impurity.link ../../resources/fonts;

  xdg.configFile = {
    qtile.source = impurity.link ../qtile;
    alacritty.source = impurity.link ../alacritty;
    qutebrowser.source = impurity.link ../qutebrowser;
    rofi.source = impurity.link ../rofi;
    kitty.source = impurity.link ../kitty;
    waybar.source = impurity.link ../waybar;
    eww.source = impurity.link ../eww;
    anyrun.source = impurity.link ../anyrun;
    wlogout.source = impurity.link ../wlogout;

    "hypr/hyprpaper.conf".source = impurity.link ../hypr/hyprpaper.conf;
    "hypr/hyprlock.conf".source = impurity.link ../hypr/hyprlock.conf;

    "dunst/dunstrc".source = impurity.link ../dunst/dunstrc;
  };

  home.file.".background-image".source = impurity.link ../../resources/wallpapers/default.jpg;

  home.file.".icons/McMojava-X-cursors".source = ../../resources/icons/McMojava-X-cursors;
  home.file.".icons/McMojava-hypr-cursors".source = ../../resources/icons/McMojava-hypr-cursors;


}
