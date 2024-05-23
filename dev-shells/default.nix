{ pkgs, ... }: {
  x86_64-linux.android-re = import ./android-re.nix { inherit pkgs; };
  x86_64-linux.aosp-dev = import ./aosp-dev.nix { inherit pkgs; };
}