{ pkgs, ... }: {
  x86_64-linux.android-re = import ./android-re.nix { inherit pkgs; };
}