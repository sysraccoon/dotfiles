{
  lib,
  llvmPackages_11,
  cmake,
  spdlog,
  abseil-cpp
}:

llvmPackages_11.stdenv.mkDerivation rec {
  pname = "c-template";
  version = "0.1.0";

  src = ./.;
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = ''
      A template for Nix based C project
    '';
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.sysraccoon ];
  };
}
