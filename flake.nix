{
  description = "sys.raccoon nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
    }; 

    hyprland = {
      url = "github:hyprwm/Hyprland?ref=v0.40.0";
    };

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    # templates
    templates.url = "path:./templates";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nur,
    hyprland,
    hy3,
    templates,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config = { allowUnfree = true; };
    };
    pkgs-nur = import nur {
      inherit pkgs;
      nurpkgs = pkgs;
    };
  in
  {
    nixosConfigurations =
    let
      generate-nixos-config = { base-config-path, ... }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            hyprland.nixosModules.default
            base-config-path
          ];
          specialArgs = {
            inherit pkgs pkgs-stable inputs;
          };
        };
    in {
      home-pc = generate-nixos-config { base-config-path = ./hosts/home-pc/configuration.nix; };
      thinkpad-yoga = generate-nixos-config { base-config-path = ./hosts/thinkpad-yoga/configuration.nix; };
    };

    homeConfigurations = 
    let
      generate-home-config = ctx @ { profile-entry, profile-dir-path, username, system, ... }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            hyprland.homeManagerModules.default
            profile-entry
          ];
          extraSpecialArgs = {
            inherit pkgs pkgs-stable pkgs-nur inputs ctx;
          };
        };
    in {
      raccoon = generate-home-config {
        profile-entry = ./profiles/raccoon/configs/nixpkgs/home.nix;
        profile-dir-path = ./profiles/raccoon;
        username = "raccoon";
        inherit system;
      };
      gopher = generate-home-config {
        profile-entry = ./profiles/gopher/configs/nixpkgs/home.nix;
        profile-dir-path = ./profiles/gopher;
        username = "gopher";
        inherit system;
      };
    };

    templates = templates.templates;
  };
}
