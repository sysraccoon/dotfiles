{ config, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Europe/Minsk";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set preffered console keymap
  console.keyMap = "dvorak";

  services.xserver = {
    layout = "us,ru";
    xkbVariant = "dvorak,";
    xkbOptions = "grp:alt_shift_toggle,ctrl:nocaps,altwin:swap_lalt_lwin,terminate:ctrl_alt_bksp";
  };
}
