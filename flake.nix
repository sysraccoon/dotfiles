{
  description = "sys.raccoon nixos system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-23.05";
    nur.url = "github:nix-community/NUR"; 
    hyprland.url =  "github:hyprwm/Hyprland?ref=v0.40.0";
    nix-alien.url = "github:thiagokokada/nix-alien";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };

    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    adb-install-cert = {
      url = "git+ssh://git@github.com/sysraccoon/adb-install-cert";
      inputs.nixpkgs.follows = "nixpkgs";
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
    android-nixpkgs,
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
            {
              imports = [ ./lib/impurity.nix ];
              impurity.configRoot = self;
            }

            android-nixpkgs.hmModule
            hyprland.homeManagerModules.default
            profile-entry
          ];
          extraSpecialArgs = {
            inherit pkgs pkgs-stable pkgs-nur inputs ctx;
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

    templates = templates.templates;

    devShells.${system}.android-re =
      let
        android = {
          versions = {
            tools = "26.1.1";
            platformTools = "33.0.3";
            buildTools = "30.0.3";
            emulator = "31.3.14";
          };
          platforms = [ "34" ];
          abis = [ "x86_64" ];
          systemImageTypes = [ "default" "google_apis" ];
        };
        androidEnv = pkgs.androidenv;
        androidComposition = androidEnv.composeAndroidPackages {
          toolsVersion = android.versions.tools;
          platformToolsVersion = android.versions.platformTools;
          buildToolsVersions = [ android.versions.buildTools ];

          includeSystemImages = true;
          platformVersions = android.platforms;
          abiVersions = android.abis;

          includeEmulator = true;
          emulatorVersion = android.versions.emulator;
          systemImageTypes = android.systemImageTypes;

          useGoogleAPIs = true;

          extraLicenses = [
            "android-sdk-preview-license"
            "android-googletv-license"
            "android-sdk-arm-dbt-license"
            "google-gdk-license"
            "intel-android-extra-license"
            "intel-android-sysimage-license"
            "mips-android-sysimage-license"
          ];
        };
        androidSdk = androidComposition.androidsdk;
      in
      (pkgs.buildFHSUserEnv
      {
        name = "android-re";
        targetPkgs = pkgs: (with pkgs;
          [
            android-studio
            androidSdk
          ]
        );
        profile = ''
          export JAVA_HOME=$(readlink -e $(type -p javac) | sed  -e 's/\/bin\/javac//g')
          export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
          export ANDROID_SDK_ROOT="${androidSdk}/libexec/android-sdk"
          export ANDROID_USER_HOME="$HOME/.android"
          export ANDROID_AVD_HOME="$HOME/.android/avd"
          export QT_QPA_PLATFORM="wayland;xcb"
        '';
      }).env;
  };


}
