{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    fuse
    ntfs3g
    vim
  ];

  programs.zsh.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries =
      (pkgs.steam-run.fhsenv.args.multiPkgs pkgs)
      ++ (with pkgs; [
        xorg.libxkbfile
      ]);
  };

  programs.steam = {
    enable = true;
  };
}
