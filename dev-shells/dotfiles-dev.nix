{
  self,
  pkgs,
  pre-commit-check,
  poetry2nix,
  ...
}: let
  pypkgs-build-requirements = {
    mawk = ["poetry"];
    brei = ["poetry"];
    entangled-cli = ["poetry"];
  };
  p2n-overrides = p2n:
    p2n.defaultPoetryOverrides.extend (final: prev:
      builtins.mapAttrs (
        package: build-requirements:
          (builtins.getAttr package prev).overridePythonAttrs (old: {
            buildInputs =
              (old.buildInputs or [])
              ++ (builtins.map (pkg:
                if builtins.isString pkg
                then builtins.getAttr pkg prev
                else pkg)
              build-requirements);
          })
      )
      pypkgs-build-requirements);

  p2n = poetry2nix.lib.mkPoetry2Nix {inherit pkgs;};
in
  pkgs.mkShell {
    inherit (pre-commit-check) shellHook;
    buildInputs =
      pre-commit-check.enabledPackages
      ++ (with pkgs; [
        just
        poetry
        (p2n.mkPoetryEnv {
          projectDir = self;
          overrides = p2n-overrides p2n;
        })
      ]);
  }
