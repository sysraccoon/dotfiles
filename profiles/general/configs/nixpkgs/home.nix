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
    ion
    git
    git-lfs
    gh
    curl
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
    xkb-switch
    jq
    bashmount
    nix-index
    nix-template
    starship
    pandoc
    dtrx
    avfs
    zip
    fd
    unzip
    unrar
    poppler_utils
    file
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
    tokei
    bitwarden-desktop
    bitwarden-cli

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
    coq_8_16
  ];

  sys.home.editors.nvim.enable = true;
  sys.home.editors.vscodium.enable = true;
  sys.home.tools.tmux.enable = true;
  sys.home.tools.zathura.enable = true;

  programs.ranger = {
    enable = true;
    extraConfig = ''
      set preview_images true
      set preview_images_method kitty
    '';
  };

  xdg.configFile = {
    radare2.source = impurity.link ../radare2;
    btop.source = impurity.link ../btop;
  };

  home.file.".gitconfig".source = impurity.link ../git/gitconfig;
  home.file.".profile".source = impurity.link ../shell/profile;
  home.file."bin".source = impurity.link ../../bin;

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };
}
