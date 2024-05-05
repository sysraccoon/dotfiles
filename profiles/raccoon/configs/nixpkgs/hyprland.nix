{ system, config, pkgs, inputs, lib, host-profile, overlays, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    plugins = [
      inputs.hy3.packages.${system}.default
    ];

    extraConfig = ''
          source = ${config.lib.file.mkOutOfStoreSymlink ../hypr/hyprland.conf}
    '';
  };
}
