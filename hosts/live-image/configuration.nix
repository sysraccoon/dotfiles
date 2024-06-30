{
  config,
  pkgs,
  lib,
  pkgs-nur,
  inputs,
  bundles,
  options,
  ...
}: let
  username = config.sys.nixos.mainUser.username;
in {
  imports = let
    nixpkgsModules = "${inputs.nixpkgs}/nixos/modules";
  in [
    "${nixpkgsModules}/installer/cd-dvd/iso-image.nix"
    "${nixpkgsModules}/profiles/base.nix"
    "${nixpkgsModules}/profiles/all-hardware.nix"

    inputs.home-manager.nixosModules.home-manager
    bundles.general.nixosModules.default
    ../general/configuration.nix
  ];

  system.stateVersion = "22.11";
  networking.hostName = "live-image";

  # Adds terminus_font for people with HiDPI displays
  console.packages = options.console.packages.default ++ [pkgs.terminus_font];
  # ISO naming.
  isoImage.isoName = "${config.isoImage.isoBaseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso";
  # EFI booting
  isoImage.makeEfiBootable = true;
  # USB booting
  isoImage.makeUsbBootable = true;
  # Add Memtest86+ to the CD.
  boot.loader.grub.memtest86.enable = true;

  users.users.${username}.password = username;
  programs.zsh.enable = true;

  specialisation.hi-dpi.configuration = {
    console.font = "ter-132b";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs pkgs-nur;
      isStandaloneHome = false;
    };
    users.${username} = {pkgs, ...}: {
      imports = [
        bundles.general.homeManagerModules.default
        ../../profiles/general/configs/nixpkgs/home.nix
      ];
      home.stateVersion = config.system.stateVersion;

      home.username = username;
      home.homeDirectory = "/home/${username}";

      home.file."dotfiles".source = ../../.;

      sys.home.browsers.firefox.enable = true;
      sys.home.terminals.kitty.enable = true;
      sys.home.desktops.hyprland-desktop.enable = true;
    };
  };

  sys.nixos.desktops.hyprland-desktop = {
    enable = true;
    isDefaultDesktop = true;
  };

  sys.nixos.network.enable = true;
  hardware.pulseaudio.enable = lib.mkForce false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
