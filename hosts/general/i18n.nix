{ config, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Europe/Minsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console.useXkbConfig = true;

  services.xserver = {
    layout = "us,ru";
    xkbVariant = "dvorak,";
    xkbOptions = "grp:alt_shift_toggle,ctrl:nocaps,altwin:swap_lalt_lwin,terminate:ctrl_alt_bksp";
  };

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Ubuntu" ]; })
      carlito
      dejavu_fonts
      ipafont
      kochi-substitute
      source-code-pro
      ttf_bitstream_vera
      baekmuk-ttf
      nanum
    ];
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
}
