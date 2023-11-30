
{ config, pkgs, lib, host-profile, overlays, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    nvidiaPatches = false;
    systemdIntegration = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    extraConfig = ''
      # Execute your favorite apps at launch
      # exec-once = waybar & hyprpaper & firefox
      exec-once = cliphist
      exec-once = swaybg --image ~/dotfiles/profiles/raccoon/resources/wallpapers/default.jpg --mode fill
      # exec-once = eww daemon & eww open bar

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      # Enable cursor
      env = WLR_NO_HARDWARE_CURSORS,1
      # Some default env vars.
      env = XCURSOR_SIZE,24

      master {
        no_gaps_when_only = 1
      }

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = us,ru
          kb_variant = dvorak,
          kb_model =
          kb_options = altwin:swap_lalt_lwin,ctrl:nocaps,grp:shifts_toggle
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = false
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          gaps_in = 3
          gaps_out = 3
          border_size = 2
          col.active_border = rgba(4c566aff) rgba(eceff4ff) 45deg
          col.inactive_border = rgba(3b4252ff)

          layout = master
      }

      decoration {
          rounding = 3
          blur = true
          blur_size = 3
          blur_passes = 1
          blur_new_optimizations = true

          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = true

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
      }

      dwindle {
          pseudotile = true # master switch for pseudotiling. Enabling is bound to mod + P in the keybinds section below
          preserve_split = true # you probably want this
      }

      master {
          new_is_master = false
          no_gaps_when_only = true
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = false
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      device:epic-mouse-v1 {
          sensitivity = -0.5
      }
            
      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mod, RETURN, exec, kitty
      bind = $mod, C, killactive,
      bind = $mod, M, exit,
      bind = $mod, E, exec, dolphin
      bind = $mod, V, togglefloating,
      bind = $mod, SPACE, exec, rofi -show drun
      bind = $mod, P, pseudo, # dwindle
      bind = $mod, F, fullscreen,
      # bind = $mod, J, togglesplit, # dwindle

      # Move focus with mod + hjkl
      bind = $mod, H, movefocus, l
      bind = $mod, L, movefocus, r
      bind = $mod, K, movefocus, u
      bind = $mod, J, movefocus, d

      # Move window with mod + hjkl
      bind = $mod SHIFT, H, movewindow, l
      bind = $mod SHIFT, L, movewindow, r
      bind = $mod SHIFT, K, movewindow, u
      bind = $mod SHIFT, J, movewindow, d

      $resize_sensitive = 100

      bind = $mod CTRL, H, resizeactive, -$resize_sensitive 0
      bind = $mod CTRL, J, resizeactive, 0 $resize_sensitive
      bind = $mod CTRL, K, resizeactive, 0 -$resize_sensitive
      bind = $mod CTRL, L, resizeactive, $resize_sensitive 0

      # Switch workspaces with mod + [0-9]
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10

      # Move active window to a workspace with mod + SHIFT + [0-9]
      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      bind = $mod SHIFT, 5, movetoworkspace, 5
      bind = $mod SHIFT, 6, movetoworkspace, 6
      bind = $mod SHIFT, 7, movetoworkspace, 7
      bind = $mod SHIFT, 8, movetoworkspace, 8
      bind = $mod SHIFT, 9, movetoworkspace, 9
      bind = $mod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mod + scroll
      bind = $mod, mouse_down, workspace, e+1
      bind = $mod, mouse_up, workspace, e-1

      # Move/resize windows with mod + LMB/RMB and dragging
      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow
    '';
  };
}
