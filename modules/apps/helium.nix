{ fetchurl, appimageTools, stdenv }:

let
  pname = "helium-browser";
  version = "0.10.2.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "sha256-Kh6UgdleK+L+G4LNiQL2DkQIwS43cyzX+Jo6K0/fX1M=";
  };
in

appimageTools.wrapType2 { inherit pname version src; }
