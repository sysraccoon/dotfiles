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
  programs.nix-ld.enable = true;

  programs.steam = {
    enable = true;
  };
}
