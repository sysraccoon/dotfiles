{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = [
    (pkgs.python312.withPackages (ps:
      with ps; [
        virtualenv
      ]))
  ];
}
