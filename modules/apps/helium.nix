{ fetchurl, appimageTools, makeDesktopItem }:

let
  pname = "helium-browser";
  version = "0.10.4.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "sha256-JjNtf5UoGIQ8fkHqsWAERmKRLc3FKIr11fnoRhuZCSQ=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    desktopName = "Helium";
    comment = "Web browser";
    exec = "${pname} %U";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    icon = pname;
    startupWMClass = "helium-browser";
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${desktopItem}/share/applications/${pname}.desktop \
      -t "$out/share/applications"
  '';
}

