{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sys.nixos.programs.caps2esc;
in {
  options.sys.nixos.programs.caps2esc = {
    enable = lib.mkEnableOption "toggle custom caps2esc setup";
  };

  config = lib.mkIf cfg.enable {
    # interception-tools package patched
    # see $DOTFILES/overlays/interception-tools/default.nix for more information
    services.interception-tools = let
      dualFunctionKeysConfig = pkgs.writeText "dual-func-keys.yaml" ''
        TIMING:
          TAP_MILLISEC: 200
          DOUBLE_TAP_MILLISEC: 150

        MAPPINGS:
          - KEY: KEY_LEFTCTRL
            TAP: KEY_ESC
            HOLD: KEY_LEFTCTRL
      '';
      udevmonConfig = ''
        - JOB: "intercept -g $DEVNODE | dual-function-keys -c ${dualFunctionKeysConfig} | uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_LEFTCTRL]
      '';
    in {
      enable = true;
      plugins = with pkgs; [
        interception-tools-plugins.dual-function-keys
      ];
      udevmonConfig = udevmonConfig;
    };
  };
}
