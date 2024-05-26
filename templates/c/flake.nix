{
  description = "C project template";

  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    # to work with older version of flakes
    lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
    # Generate a user-friendly version number.
    version = builtins.substring 0 8 lastModifiedDate;
    # System types to support.
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });
  in {
    # Provide some binary packages for selected system types.
    packages = forAllSystems ({pkgs}: {
      default = pkgs.callPackage ./default.nix {};
    });

    templates.default = {
      path = ./.;
    };
  };
}
