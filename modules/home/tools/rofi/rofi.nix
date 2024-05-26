{
  config,
  lib,
  pkgs,
  impurity,
  ...
}: let
  cfg = config.sys.home.tools.rofi;
in {
  options.sys.home.tools.rofi = {
    enable = lib.mkEnableOption "toggle custom rofi setup";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-wayland
    ];

    xdg.configFile."rofi/config.rasi".text = let
      colors = config.lib.stylix.colors.withHashtag;
      palette = ''
        * {
          color0: ${colors.base00};
          color1: ${colors.base01};
          color2: ${colors.base02};
          color3: ${colors.base03};
          color4: ${colors.base04};
          color5: ${colors.base05};
          color6: ${colors.base06};
          color7: ${colors.base07};
          color8: ${colors.base08};
          color9: ${colors.base09};
          color10: ${colors.base10};
          color11: ${colors.base11};
          color12: ${colors.base12};
          color13: ${colors.base13};
          color14: ${colors.base14};
          color15: ${colors.base15};
        }
      '';
      theme = ''
        ${palette}
        /*
        import here allow me to dynamically change theme parameters
        but only if impurity actually enabled
        */
        @import "${impurity.link ./theme.rasi}"
      '';
    in ''
      /* @theme reset all previusly initialized style parameters */
      @theme "${pkgs.writeText "complete-theme.rasi" theme}"
    '';

    # Don't like how look's default stylix rofi customization
    # instead I manually set stylix parameters to rofi
    stylix.targets.rofi.enable = false;
  };
}
