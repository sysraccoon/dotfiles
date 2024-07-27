{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.poetry
    (pkgs.python312.withPackages (ps:
      with ps; [
        virtualenv
      ]))
  ];
}
