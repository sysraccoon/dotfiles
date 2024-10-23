{
  appimageTools,
  fetchurl,
}: let
  pname = "kando";
  version = "1.4.0";
  src = fetchurl {
    url = "https://github.com/kando-menu/kando/releases/download/v${version}/Kando-${version}-x86_64.AppImage";
    hash = "sha256-YGuP3gZX0jL3zljYlFvW+DC/9+4Ulw+GJq3U0LsW5BQ=";
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;
  }
