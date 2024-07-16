{
  self,
  pkgs,
  inputs,
  ...
}: let
  system = "x86_64-linux";
in {
  "${system}" = rec {
    android-emu = import ./android-emu.nix {inherit pkgs;};
    android-re = import ./android-re.nix {inherit pkgs;};
    python-venv = import ./python-venv.nix {inherit pkgs;};
    aosp-dev = import ./aosp-dev.nix {inherit pkgs;};
    dotfiles-dev = import ./dotfiles-dev.nix {
      inherit self pkgs;
      pre-commit-check = self.checks.${system}.pre-commit-check;
      poetry2nix = inputs.poetry2nix;
    };
    default = dotfiles-dev;
  };
}
