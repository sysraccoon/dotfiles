{ config, pkgs, inputs, lib, host-profile, overlays, ctx, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [
      inputs.hy3.packages.${ctx.system}.default
    ];

    extraConfig = let impureSymlink = config.lib.file.mkOutOfStoreSymlink; in
    ''
          source = ${impureSymlink ../hypr/hyprland.conf}
    '';
  };

  # hotfix breaking change of hyprland v0.40.0
  # see release page: https://github.com/hyprwm/Hyprland/releases/tag/v0.40.0
  home.activation.fix-hyprland-runtime-dir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ln -sf $XDG_RUNTIME_DIR/hypr /tmp/hypr 
  '';
}
