{ config, pkgs, lib, host-profile, overlays, ... }:

{

  imports = [
    ./screencast.nix
    ./hyprland.nix
    ./firefox.nix
    ./vscodium.nix
    ./emacs.nix
  ];

  home.stateVersion = "22.11";

  home.username = "raccoon";
  home.homeDirectory = "/home/raccoon";

  home.keyboard = {
    layout = "us,ru";
    variant = "dvorak,";
    options = [
      "grp:alt_shift_toggle"
      "ctrl:nocaps"
      "altwin:swap_lalt_lwin"
      "terminate:ctrl_alt_bksp"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # build
    gcc
    libgccjit

    # terminals
    kitty
    alacritty
    xterm

    # cli tools
    zsh
    ion
    git
    gh
    curl
    tmux
    screen
    tldr
    zoxide
    xclip
    ripgrep
    dua
    p7zip
    fzf
    htop
    openssh
    ranger
    xkb-switch
    jq
    bashmount
    nix-index
    nix-template
    starship
    direnv
    nix-direnv
    nix-direnv-flakes
    pandoc
    texlive.combined.scheme-full
    # dtrx
    avfs
    zip
    fd
    unzip
    unrar
    exa
    xdragon
    poppler_utils
    btop
    file
    bat
    translate-shell
    du-dust
    vagrant
    qemu

    # browsers
    qutebrowser

    # gui tools

    ## general
    jetbrains.pycharm-community
    zathura
    discord
    tdesktop
    libreoffice
    obs-studio
    mpv
    rofi
    cinnamon.nemo
    calibre

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

    # dev
    (python39.withPackages (ps: with ps; [
      pip
      pandocfilters
    ]))

    gnumake
    mitmproxy
    gdb

    jetbrains.idea-community

    ghidra
    radare2
    pwntools
    hyx
    jadx
    imhex
    unicorn

    nodejs
    nil
    coq_8_16
  ];


  xsession.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.neovim = {
    enable = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      jedi
      pynvim
    ]);
  };

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

  xdg.configFile = {
    qtile.source = ../qtile;
    nvim.source = ../nvim;
    alacritty.source = ../alacritty;
    qutebrowser.source = ../qutebrowser;
    rofi.source = ../rofi;
    tmux.source = ../tmux;
    dunst.source = ../dunst;
    kitty.source = ../kitty;
    starship.source = ../starship;
    waybar.source = ../waybar;
    eww.source = ../eww;
    radare2.source = ../radare2;
    btop.source = ../btop;
  };

  xdg.dataFile.fonts.source = ../../resources/fonts;

  home.file.".gitconfig".source  = ../git/gitconfig;
  home.file.".zshrc".source = ../zsh/zshrc;
  home.file.".profile".source = ../shell/profile;
  home.file."bin".source = ../../bin;
}
