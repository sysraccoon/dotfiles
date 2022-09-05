{ config, pkgs, ...}:

{
  home.stateVersion = "22.05";

  home.username = "raccoon";
  home.homeDirectory = "/home/raccoon";

  home.keyboard = {
    layout = "us,ru";
    variant = "dvorak,";
    options = [
      "grp:alt_shift_toggle"
      "ctrl:nocaps"
      "terminate:ctrl_alt_bksp"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # terminals
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

    # browsers
    firefox
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

    # audio
    alsa-tools
    alsa-utils
    pamixer

    (python39.withPackages (ps: with ps; [
      pip
    ]))
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

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

  programs.git = {
    enable = true;
    userName = "sysraccoon";
    userEmail = "sysraccoon@gmail.com";
    extraConfig = {
      core.editor = "nvim";
      pull.rebase = false;
      init.defaultBranch = "main";
    };
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

  services.dunst = {
    enable = true;
    settings = {
      global = {
        flame_color = "#2e3440";
        separator_color = "auto";
      };
      nord_low = {
        msg_urgency = "low";
        background = "#4c566a";
        foreground = "#d8dee9";
      };
      nord_normal = {
        msg_urgency = "normal";
        background = "#5e81ac";
        foreground = "#eceff4";
      };
      nord_critical = {
        msg_urgency = "critical";
        background = "#bf616a";
        foreground = "#eceff4";
      };
    };
  };

  services.flameshot.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
      "x-scheme-handler/http" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/https" = ["org.qutebrowser.qutebrowser.desktop"];
      "x-scheme-handler/tg" = ["userapp-Telegram Desktop-08XUJ1.desktop"];
    };
  };

  xdg.configFile.qtile.source = ../qtile;
  xdg.configFile.nvim.source = ../nvim;
  xdg.configFile.alacritty.source = ../alacritty;
  xdg.configFile.qutebrowser.source = ../qutebrowser;
  xdg.configFile.rofi.source = ../rofi;
  xdg.configFile.tmux.source = ../tmux;
}
