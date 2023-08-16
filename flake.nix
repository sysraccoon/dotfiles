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

    nh = {
      url = "github:viperML/nh";
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
    nh,
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
            nh.nixosModules.default
            {
              nh = {
                enable = true;
                clean.enable = true;
                clean.extraArgs = "--keep-since 4d --keep 3";
              };
            }
          ];
          specialArgs = {
            inherit pkgs pkgs-stable;
          };
        };
    in {
      home-pc = generate-nixos-config { base-config-path = ./hosts/home-pc/configuration.nix; };
      thinkpad-yoga = generate-nixos-config { base-config-path = ./hosts/thinkpad-yoga/configuration.nix; };
    };

    homeConfigurations = 
    let
      generate-home-config = { base-config-path, ... }:
        home-manager.lib.homeManagerConfiguration {
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
    in {
      raccoon = generate-home-config { base-config-path = ./profiles/raccoon/configs/nixpkgs/home.nix; };
      gopher = generate-home-config { base-config-path = ./profiles/gopher/configs/nixpkgs/home.nix; };
    };

    templates = templates.templates;
  };
}
