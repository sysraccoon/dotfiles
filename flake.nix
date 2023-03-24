{
  description = "sys.raccoon nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-22.11";
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
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nur,
    nix-doom-emacs,
    hyprland,
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
    nixosConfigurations = {
      # home pc host
      home-pc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          hyprland.nixosModules.default
          ./hosts/home-pc/configuration.nix
        ];
        specialArgs = {
          inherit pkgs pkgs-stable;
        };
      };
    };

    homeConfigurations = {
      # use this profile for personal projects, web surfing etc
      home = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nix-doom-emacs.hmModule
          hyprland.homeManagerModules.default
          ./profiles/home/configs/nixpkgs/home.nix
        ];
        extraSpecialArgs = {
          inherit pkgs pkgs-stable pkgs-nur;
        };
      };
    };
  };
}
