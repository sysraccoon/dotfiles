{
  nixosModules.default =
    { config, pkgs, lib, inputs, ... }:
    let
      cfg = config.sys.nixos.desktops.gnome-desktop;
    in {
      options.sys.nixos.desktops.gnome-desktop = {
        enable = lib.mkEnableOption "enable custom gnome setup";
        isDefaultDesktop = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "set gnome as default in display manager";
        };
      };

      config = lib.mkIf cfg.enable {
        services.xserver.enable = true;
        services.xserver.desktopManager.gnome.enable = true;

        services.displayManager = lib.mkIf cfg.isDefaultDesktop {
          defaultSession = "gnome";
        };
      };
    };

  homeManagerModules.default =
    { config, pkgs, lib, impurity, inputs, ... }: 
    let
      cfg = config.sys.home.desktops.gnome-desktop;
    in {
      options.sys.home.desktops.gnome-desktop = {
        enable = lib.mkEnableOption "enable custom hyprland setup";
        extraConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };

      config = lib.mkIf cfg.enable 
      {
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
      };
    };
}