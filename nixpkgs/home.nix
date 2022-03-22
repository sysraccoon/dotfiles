{ config, pkgs, ... }:

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
      "altwin:swap_lalt_lwin"
      "terminate:ctrl_alt_bksp"
    ];
  };

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
    neovim
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

    # browsers
    firefox
    qutebrowser

    # gui tools
    rofi
    feh
    mpv
    flameshot
    zathura

    # audio
    alsa-tools
    alsa-utils
    pamixer
  ];

  xsession.enable = true;

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
  };

  services.random-background = {
    enable = true;
    imageDirectory = "%h/dotfiles/resources";
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
    };
  };
}
