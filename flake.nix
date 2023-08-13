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
      # inputs.nixpkgs.follows = "nixpkgs";
    }; 
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # templates
    templates.url = "path:./templates";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nur,
    nix-doom-emacs,
    hyprland,
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
            inherit pkgs pkgs-stable;
          };
        };
    in {
      home-pc = generate-nixos-config { base-config-path = ./hosts/home-pc/configuration.nix; };
      thinkpad-yoga = generate-nixos-config { base-config-path = ./hosts/thinkpad-yoga/configuration.nix; };
    };

    homeConfigurations = {
      # use this profile for personal projects, web surfing etc
      raccoon = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nix-doom-emacs.hmModule
          hyprland.homeManagerModules.default
          ./profiles/raccoon/configs/nixpkgs/home.nix
        ];
        extraSpecialArgs = {
          inherit pkgs pkgs-stable pkgs-nur;
        };
      };
    };

    templates = templates.templates;
  };
}
