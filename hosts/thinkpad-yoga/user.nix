{
  pkgs,
  bundles,
  inputs,
  username,
  homeDir,
  impurity,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;

  sys.nixos.desktops.hyprland-desktop = {
    enable = true;
    isDefaultDesktop = true;
  };

  sys.nixos.syncthing = {
    enable = true;
    user = username;
    openDefaultPorts = true;
  };

  home-manager.users.${username} = {
    imports = [
      inputs.hyprland.homeManagerModules.default
      bundles.general.homeManagerModules.default
    ];

    home.stateVersion = "22.11";
    home.username = username;
    home.homeDirectory = homeDir;

    sys.home.browsers.firefox.enable = true;

    sys.home.desktops.hyprland-desktop = {
      enable = true;
      extraConfig = ''
        monitor = eDP-1,1920x1080,auto,1
        animations:enabled = false
        misc:vfr = true
      '';
    };

    sys.home.terminals.alacritty.enable = true;
    sys.home.terminals.kitty.enable = true;

    home.packages = with pkgs; [
      ## general
      zathura
      discord
      tdesktop
      libreoffice
      obs-studio
      gnome.gnome-sound-recorder
      mpv
      calibre
      tor-browser-bundle-bin
      rtorrent
      qbittorrent
      pavucontrol
      emote
      gparted
      google-chrome
      asciinema

      # knowledge management
      obsidian

      # audio
      alsa-tools
      alsa-utils
      pamixer
    ];

    xdg.configFile."mimeapps.list".force = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = ["org.pwmt.zathura.desktop"];
      };
    };

    xdg.dataFile.fonts.source = impurity.link ../../resources/fonts;

    home.file.".background-image".source = impurity.link ../../resources/wallpapers/default.jpg;

    home.file.".icons/McMojava-X-cursors".source = ../../resources/icons/McMojava-X-cursors;
    home.file.".icons/McMojava-hypr-cursors".source = ../../resources/icons/McMojava-hypr-cursors;
  };
}
