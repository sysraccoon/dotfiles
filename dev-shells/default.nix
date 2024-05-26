{
  self,
  pkgs,
  ...
}: let
  system = "x86_64-linux";
in {
  "${system}" = {
    android-re = import ./android-re.nix {inherit pkgs;};
    aosp-dev = import ./aosp-dev.nix {inherit pkgs;};
    default = pkgs.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
    };
  };
}
