{ pkgs ? import <nixpkgs> {}, icon }:

pkgs.stdenv.mkDerivation {
  pname = "helium-browser";
  version = "0.5.8.1";
  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/0.5.8.1/helium-0.5.8.1-x86_64.AppImage";
    sha256 = "sha256-d8kwLEU6qgEgp7nlEwdfRevB1JrbEKHRe8+GhGpGUig=";
  };
  unpackPhase = "true";
  buildInputs = [ pkgs.appimage-run ];
  installPhase = ''
    mkdir -p $out/bin $out/share/appimage $out/share/applications $out/share/pixmaps
    cp $src $out/share/appimage/helium-browser.AppImage
    cat > $out/bin/helium-browser <<EOF
    #!${pkgs.stdenv.shell}
    exec ${pkgs.appimage-run}/bin/appimage-run $out/share/appimage/helium-browser.AppImage "\$@"
    EOF
    chmod +x $out/bin/helium-browser

    cat > $out/share/applications/helium-browser.desktop <<EOF
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Helium Browser
    Exec=$out/bin/helium-browser
    Icon=helium-browser
    Terminal=false
    Categories=Network;WebBrowser;
    EOF

    cp ${icon} $out/share/pixmaps/helium-browser.png
  '';
  meta = with pkgs.lib; {
    description = "Helium Browser (AppImage wrapper)";
    homepage = "https://github.com/imputnet/helium-linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}