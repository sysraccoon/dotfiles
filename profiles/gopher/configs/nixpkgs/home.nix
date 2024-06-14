{
  pkgs,
  ctx,
  bundles,
  impurity,
  ...
}: {
  imports = [
    bundles.general.homeManagerModules.default
    ../../../general/configs/nixpkgs/home.nix
  ];

  home.stateVersion = "22.11";

  home.username = ctx.username;
  home.homeDirectory = "/home/${ctx.username}";

  home.packages = with pkgs; [
    ## general
    zathura
    discord
    tdesktop
    mpv
    pavucontrol
    gparted
    texlive.combined.scheme-full
    libreoffice

    # knowledge management
    obsidian

    # audio
    alsa-tools
    alsa-utils
    pamixer
  ];

  sys.home.browsers.firefox.enable = true;

  sys.home.desktops.hyprland-desktop = {
    enable = true;
    extraConfig = ''
      source = ${impurity.link ../hypr/hyprland.conf}
    '';
  };

  sys.home.terminals.kitty.enable = true;

  xdg.dataFile.fonts.source = impurity.link ../../../resources/fonts;

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    duskTime = "18:35-20:15";
    dawnTime = "6:00-7:45";
  };
}
