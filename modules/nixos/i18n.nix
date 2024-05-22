{ config, lib, pkgs, ... }:

let
  cfg = config.sys.nixos.i18n;
in {

  options.sys.nixos.i18n = {
    enable = lib.mkEnableOption "enable internationalization preset";
    fontPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        (nerdfonts.override { fonts = [ "Ubuntu" ]; })
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
        noto-fonts-emoji
        symbola
        material-symbols
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

    console.useXkbConfig = true;

    services.xserver.xkb = {
      layout = "us,ru";
      variant = "dvorak,";
      options = "grp:shifts_toggle,ctrl:nocaps,altwin:swap_lalt_lwin,terminate:ctrl_alt_bksp";
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

