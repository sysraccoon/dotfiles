let
  hyprland-desktop = import ./hyprland-desktop/hyprland-desktop.nix;
in {
  nixosModules.default = {
    imports = [
      hyprland-desktop.nixosModules.default
    ];
  };

  homeManagerModules.default = {
    imports = [
      hyprland-desktop.homeManagerModules.default
    ];
  };

  nixosModules.hyprland-desktop = hyprland-desktop.nixosModules.default;
  homeManagerModules.hyprland-desktop = hyprland-desktop.homeManagerModules.default;
}