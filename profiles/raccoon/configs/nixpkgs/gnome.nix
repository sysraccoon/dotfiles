{
  pkgs,
  lib,
  ...
}: {
  dconf.settings = let
    u32 = lib.hm.gvariant.mkUint32;
  in {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 4;
    };

    "system/locale" = {
      region = "en_GB.UTF-8";
    };

    "org/gnome/shell" = {
      disabled-user-extensions = false;
      enabled-extensions = [
        "gSnap@micahosborne"
        "pop-shell@system76.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
      ];
    };

    "org/gnome/shell/extensions/pop-shell" = {
      show-title = true;
      smart-gaps = true;
      fullscreen-launcher = true;
      stacking-with-mouse = true;
      show-skip-taskbar = true;
      mouse-cursor-follows-active-window = true;

      gap-outer = u32 0;
      gap-inner = u32 0;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "launch-kitty";
      command = "kitty";
      binding = "<Shift><Super>Return";
    };
  };
  home.packages = with pkgs.gnomeExtensions; [
    pop-shell
    gtk-title-bar
  ];
}
