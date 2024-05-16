{ config, pkgs, inputs, lib, host-profile, overlays, ctx, impurity, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [
      inputs.hy3.packages.${ctx.system}.default
    ];

    extraConfig = ''
          source = ${impurity.link ../hypr/hyprland.conf}
    '';
  };

  xdg.configFile = {
    "hypr/hyprland-screencast.conf".source = impurity.link ../hypr/hyprland-screencast.conf;
    "hypr/hyprland-default.conf".source = impurity.link ../hypr/hyprland-default.conf;
    "hypr/hyprland-modules".source = impurity.link ../hypr/hyprland-modules;
  };

  # hotfix breaking change of hyprland v0.40.0
  # see release page: https://github.com/hyprwm/Hyprland/releases/tag/v0.40.0
  home.activation.fix-hyprland-runtime-dir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ln -sf $XDG_RUNTIME_DIR/hypr /tmp/hypr 
  '';
}
