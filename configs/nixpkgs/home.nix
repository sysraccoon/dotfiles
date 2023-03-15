{ config, pkgs, lib, ... }:

{
  imports = [
    ./firefox.nix
    ./vscodium.nix
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
    git
    gh
    curl
    tmux
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
    starship
    direnv
    nix-direnv
    dtrx
    avfs
    zip

    # browsers
    qutebrowser

    # gui tools
    rofi
    feh
    mpv
    flameshot
    zathura
    discord
    tdesktop
    libreoffice
    jetbrains.pycharm-community
    obs-studio
    xsecurelock

    # audio
    alsa-tools
    alsa-utils
    pamixer

    # fonts
    ubuntu_font_family
    source-code-pro

    # dev
    (python39.withPackages (ps: with ps; [
      pip
      mitmproxy
    ]))

    nodejs
    nil
    coq_8_16
  ];


  xsession.enable = true;

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
    backend = "glx";
  };

  services.random-background = {
    enable = true;
    imageDirectory = "%h/dotfiles/resources/wallpapers";
    display = "fill";
  };

  services.unclutter = {
    enable = true;
    timeout = 10;
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
    };
  };

  xdg.configFile.qtile.source = config.lib.file.mkOutOfStoreSymlink ../qtile;
  xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink ../nvim;
  xdg.configFile.alacritty.source = config.lib.file.mkOutOfStoreSymlink ../alacritty;
  xdg.configFile.qutebrowser.source = config.lib.file.mkOutOfStoreSymlink ../qutebrowser;
  xdg.configFile.rofi.source = config.lib.file.mkOutOfStoreSymlink ../rofi;
  xdg.configFile.tmux.source = config.lib.file.mkOutOfStoreSymlink ../tmux;
  xdg.configFile.dunst.source = config.lib.file.mkOutOfStoreSymlink ../dunst;
  xdg.configFile.kitty.source = config.lib.file.mkOutOfStoreSymlink ../kitty;
  xdg.configFile.starship.source = config.lib.file.mkOutOfStoreSymlink ../starship;

  xdg.dataFile.fonts.source = config.lib.file.mkOutOfStoreSymlink ../../resources/fonts;

  home.file.".gitconfig".source  = config.lib.file.mkOutOfStoreSymlink ../git/gitconfig;
}
