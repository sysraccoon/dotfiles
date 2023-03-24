{ config, pkgs, lib, host-profile, overlays, ... }:

{

  imports = [
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
    # dtrx
    avfs
    zip
    fd

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

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    systemdIntegration = true;
    nvidiaPatches = true;
    extraConfig = ''
      source = ${config.xdg.configHome}/hypr/custom.conf
    '';
  };
  xdg.configFile."hypr/custom.conf".source = ../hyprland/hyprland.conf;

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
  };

  xdg.dataFile.fonts.source = ../../resources/fonts;

  home.file.".gitconfig".source  = ../git/gitconfig;
  home.file.".zshrc".source = ../zsh/zshrc;
  home.file.".profile".source = ../shell/profile;
}
