{
  config,
  pkgs,
  lib,
  pkgs-nur,
  inputs,
  bundles,
  ...
}: let
  username = config.sys.nixos.mainUser.username;
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
    inputs.home-manager.nixosModules.home-manager
    bundles.general.nixosModules.default
    ../general/configuration.nix
  ];

  system.stateVersion = "22.11";
  networking.hostName = "live-cd";

  sys.nixos.desktops.hyprland-desktop = {
    enable = true;
    isDefaultDesktop = true;
  };

  programs.zsh.enable = true;

  users.users.${username}.password = "livepass";

  system.userActivationScripts.activateHomeManager.text = ''
    ${config.home-manager.users.${username}.home.activationPackage}/activate
  '';

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
      sys.home.desktops.hyprland-desktop = {
        enable = true;
      };
    };
  };

  sys.nixos.network.enable = false;
  hardware.pulseaudio.enable = lib.mkForce false;
}
