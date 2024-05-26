{
  config,
  pkgs,
  impurity,
  ...
}: {
  home.stateVersion = "22.11";

  home.keyboard = {
    layout = "us,ru";
    variant = "dvorak,";
    options = [
      "grp:shifts_toggle"
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
    poppler_utils
    eza
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
    gawk
    exfatprogs
    openssl

    # dev
    (python310.withPackages (ps:
      with ps; [
        # pip
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

  sys.home.editors.nvim.enable = true;
  sys.home.editors.vscodium.enable = true;

  xdg.configFile = {
    tmux.source = impurity.link ../tmux;
    starship.source = impurity.link ../starship;
    radare2.source = impurity.link ../radare2;
    btop.source = impurity.link ../btop;
  };

  home.file.".gitconfig".source = impurity.link ../git/gitconfig;
  home.file.".zshrc".source = impurity.link ../zsh/zshrc;
  home.file.".profile".source = impurity.link ../shell/profile;
  home.file."bin".source = impurity.link ../../bin;
}
