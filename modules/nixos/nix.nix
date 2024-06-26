{
  config,
  lib,
  ...
}: let
  cfg = config.sys.nixos.nix;
in {
  options.sys.nixos.nix = {
    enable = lib.mkEnableOption "enable nix configuration preset";
  };

  config = lib.mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
  };
}
