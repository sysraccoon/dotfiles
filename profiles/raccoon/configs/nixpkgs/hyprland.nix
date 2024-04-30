
{ config, pkgs, lib, host-profile, overlays, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      # Execute your favorite apps at launch
      # exec-once = waybar & hyprpaper & firefox

      exec-once = [
        "waybar"
        "cliphist"
        "swaybg --image ~/dotfiles/profiles/raccoon/resources/wallpapers/default.jpg --mode fill"
      ];
      # exec-once = eww daemon & eww open bar

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      env = [
        "WLR_NO_HARDWARE_CURSORS,1"
        "XCURSOR_SIZE,24"
        "WLR_DRM_DEVICES,/dev/dri/card1"
      ];

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input = {
          kb_layout = "us,ru";
          kb_variant = "dvorak,";
          kb_model = "";
          kb_options = "altwin:swap_lalt_lwin,ctrl:nocaps,grp:shifts_toggle";
          kb_rules = "";

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
          gaps_in = 3;
          gaps_out = 3;
          border_size = 2;
          "col.active_border" = "rgba(4c566aff) rgba(eceff4ff) 45deg";
          "col.inactive_border" = "rgba(3b4252ff)";

          layout = "master";
      };

      # decoration = {
          # rounding = 3;
          # blur = true;
          # blur_size = 3;
          # blur_passes = 1;
          # blur_new_optimizations = true;

          # drop_shadow = true;
          # shadow_range = 4;
          # shadow_render_power = 3;
          # col.shadow = "rgba(1a1a1aee)";
      # };

      animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 2, default"
            "workspaces, 1, 2, default"
          ];
      };

      dwindle = {
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mod + P in the keybinds section below
          preserve_split = true; # you probably want this
      };

      master = {
          new_is_master = false;
          no_gaps_when_only = true;
      };

      gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = false;
      };

      windowrule = [
        "tile, class:^(kitty)$"
      ];

      windowrulev2 = [
        "forceinput,class:(rofi)"
        "stayfocused,class:(rofi)"
      ];
            
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      "$mod" = "SUPER";
      "$resize_sensitive" = 100;

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod SHIFT, Q, exit"
        "$mod, E, exec, thunar"
        "$mod, V, togglefloating"
        "$mod, SPACE, exec, rofi -show drun"
        "$mod, P, pseudo" # dwindle
        "$mod, F, fullscreen"
        "$mod SHIFT, X, killactive"
        "$mod SHIFT, R, exec, hyprctl reload"

        # Move focus with mod + hjkl
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Move window with mod + hjkl
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"


        "$mod CTRL, H, resizeactive, -$resize_sensitive 0"
        "$mod CTRL, J, resizeactive, 0 $resize_sensitive"
        "$mod CTRL, K, resizeactive, 0 -$resize_sensitive"
        "$mod CTRL, L, resizeactive, $resize_sensitive 0"

      # Switch workspaces with mod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

      # Move active window to a workspace with mod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

      # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Move/resize windows with mod + LMB/RMB and dragging
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
