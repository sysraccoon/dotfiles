{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sys.nixos.i18n;
in {
  options.sys.nixos.i18n = {
    enable = lib.mkEnableOption "enable internationalization preset";
    fontPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        (nerdfonts.override {fonts = ["Ubuntu"];})
        carlito
        dejavu_fonts
        ipafont
        kochi-substitute
        source-code-pro
        ttf_bitstream_vera
        baekmuk-ttf
        nanum
        hack-font
        ubuntu_font_family
        source-code-pro
        babelstone-han
        symbola
        material-symbols
        noto-fonts
        noto-fonts-emoji
        noto-fonts-extra
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Set your time zone.
    time.timeZone = "Europe/Minsk";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LANGUAGE = "en_GB.UTF-8";
      LC_ALL = "en_GB.UTF-8";
    };

    fonts = {
      packages = cfg.fontPackages;
      fontconfig.enable = true;
    };

    fonts.fontconfig.defaultFonts = {
      monospace = [
        "DejaVu Sans Mono"
        "IPAGothic"
        "NanumGothic"
      ];
      sansSerif = [
        "DejaVu Sans"
        "IPAPGothic"
        "NanumGothic"
      ];
      serif = [
        "DejaVu Serif"
        "IPAPMincho"
        "NanumGothic"
      ];
    };
  };
}
