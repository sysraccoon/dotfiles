let
  gnome-desktop = import ./gnome-desktop/gnome-desktop.nix;
  hyprland-desktop = import ./hyprland-desktop/hyprland-desktop.nix;
  qtile-desktop = import ./qtile-desktop/qtile-desktop.nix;
in {
  nixosModules.default = {
    imports = [
      gnome-desktop.nixosModules.default
      hyprland-desktop.nixosModules.default
      qtile-desktop.nixosModules.default
    ];
  };

  homeManagerModules.default = {
    imports = [
      gnome-desktop.homeManagerModules.default
      hyprland-desktop.homeManagerModules.default
      qtile-desktop.homeManagerModules.default
    ];
  };

  nixosModules.hyprland-desktop = hyprland-desktop.nixosModules.default;
  homeManagerModules.hyprland-desktop = hyprland-desktop.homeManagerModules.default;

  nixosModules.gnome-desktop = gnome-desktop.nixosModules.default;
  homeManagerModules.gnome-desktop = gnome-desktop.homeManagerModules.default;

  nixosModules.qtile-desktop = qtile-desktop.nixosModules.default;
  homeManagerModules.qtile-desktop = qtile-desktop.homeManagerModules.default;
}