{
  description = "sys.raccoon nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nur.url = "github:nix-community/NUR"; 
    hyprland.url =  "github:hyprwm/Hyprland?ref=v0.40.0";
    nix-alien.url = "github:thiagokokada/nix-alien";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.40.0";
      inputs.hyprland.follows = "hyprland";
    };

    adb-install-cert = {
      url = "git+ssh://git@github.com/sysraccoon/adb-install-cert";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
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
      config = { 
        android_sdk.accept_license = true;
        allowUnfree = true;
      };
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
            inherit pkgs inputs;
          };
        };
    in {
      home-pc = generate-nixos-config { base-config-path = ./hosts/home-pc/configuration.nix; };
      thinkpad-yoga = generate-nixos-config { base-config-path = ./hosts/thinkpad-yoga/configuration.nix; };
    };

    homeManagerModules = import ./modules/home-manager // import ./modules/common;

    homeConfigurations = 
    let
      generate-home-config = ctx @ { profile-entry, profile-dir-path, username, system, ... }:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            self.homeManagerModules.impurity
            {
              impurity.configRoot = self;
            }

            hyprland.homeManagerModules.default
            profile-entry
          ];
          extraSpecialArgs = {
            inherit pkgs pkgs-nur inputs ctx;
          };
        };
    in rec {
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

      raccoon-impure = raccoon.extendModules {
        modules = [ {impurity.enable = true; } ];
      };
    };

    templates = import ./templates;
    devShells = import ./dev-shells { inherit pkgs; };
  };
}
