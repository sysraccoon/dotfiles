{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.sys.nixos.nix;
in {
  options.sys.nixos.nix = {
    enable = lib.mkEnableOption "enable nix configuration preset";
  };

  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
  };
}
