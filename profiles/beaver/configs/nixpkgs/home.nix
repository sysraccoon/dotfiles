{
  pkgs,
  inputs,
  bundles,
  impurity,
  sysUtils,
  ctx,
  ...
}: {
  imports = [
    bundles.general.homeManagerModules.default
    ../../../general/configs/nixpkgs/home.nix
  ];

  home.stateVersion = "22.11";

  home.username = ctx.username;
  home.homeDirectory = "/home/${ctx.username}";

  home.packages = with pkgs; [
    # cli
    argbash
    ibus
    ffmpeg
    openvpn
    fping
    nmap
    psmisc
    usbutils

    # dev/re
    frida-tools
    lldb_18

    # android
    scrcpy
    android-tools
    apktool
    inputs.adb-install-cert.packages.${ctx.system}.adb-install-cert
    apksigner
  ];

  sys.home.keyboard.enable = false;
}
