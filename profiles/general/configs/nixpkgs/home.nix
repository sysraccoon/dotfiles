{ config, pkgs, lib, host-profile, overlays, ... }:

{

  home.stateVersion = "22.11";

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
    dtrx
    avfs
    zip
    fd
    unzip
    unrar
    exa
    poppler_utils
    btop
    file
    bat
    translate-shell
    du-dust
    parallel
    gettext
    j2cli
    strace
    pciutils
    libinput

    # dev
    (python310.withPackages (ps: with ps; [
      pip
    ]))
    openjdk17

    gnumake
    mitmproxy
    gdb

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

  xdg.configFile = {
    nvim.source = ../nvim;
    tmux.source = ../tmux;
    starship.source = ../starship;
    radare2.source = ../radare2;
    btop.source = ../btop;
  };

  home.file.".gitconfig".source  = ../git/gitconfig;
  home.file.".zshrc".source = ../zsh/zshrc;
  home.file.".profile".source = ../shell/profile;
  home.file."bin".source = ../../bin;
}
