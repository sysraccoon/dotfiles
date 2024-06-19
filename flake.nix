{
  description = "sys.raccoon nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nur.url = "github:nix-community/NUR";
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.39.1";
    nix-alien.url = "github:thiagokokada/nix-alien";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.39.1";
      inputs.hyprland.follows = "hyprland";
    };

    stylix.url = "github:danth/stylix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    adb-install-cert = {
      url = "git+ssh://git@github.com/sysraccoon/adb-install-cert";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    overlays = import ./overlays;
    pkgs = import nixpkgs {
      inherit system;
      config = {
        android_sdk.accept_license = true;
        allowUnfree = true;
      };

      overlays = overlays.nixpkgs-overlays;
    };
    pkgs-nur = import inputs.nur {
      inherit pkgs;
      nurpkgs = pkgs;
    };

    bundles = import ./bundles;
  in {
    checks.${system}.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        alejandra.enable = true;
        nil.enable = true;
        detect-private-keys.enable = true;
      };
    };

    nixosConfigurations = let
      generate-nixos-config = {
        base-config-path,
        username,
        ...
      }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            base-config-path
          ];
          specialArgs = {
            inherit pkgs inputs bundles username;
          };
        };
    in {
      home-pc = generate-nixos-config {
        base-config-path = ./hosts/home-pc/configuration.nix;
        username = "raccoon";
      };
      thinkpad-yoga = generate-nixos-config {
        base-config-path = ./hosts/thinkpad-yoga/configuration.nix;
        username = "gopher";
      };
    };

    homeConfigurations = let
      generate-home-config = ctx @ {profile-entry, ...}:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            profile-entry
            {
              impurity.configRoot = self;
            }
          ];
          extraSpecialArgs = {
            inherit pkgs pkgs-nur inputs ctx bundles;
          };
        };
      generate-impure-version = pure-config:
        pure-config.extendModules {
          modules = [{impurity.enable = true;}];
        };
    in rec {
      raccoon = generate-home-config {
        profile-entry = ./profiles/raccoon/configs/nixpkgs/home.nix;
        profile-dir-path = ./profiles/raccoon;
        username = "raccoon";
        inherit system;
      };
      raccoon-impure = generate-impure-version raccoon;

      gopher = generate-home-config {
        profile-entry = ./profiles/gopher/configs/nixpkgs/home.nix;
        profile-dir-path = ./profiles/gopher;
        username = "gopher";
        inherit system;
      };
      gopher-impure = generate-impure-version gopher;
    };

    # templates = import ./templates;
    devShells = import ./dev-shells {inherit self pkgs;};
  };
}
