{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "helium-browser";
  version = "0.9.4.1";
  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/0.9.4.1/helium-0.9.4.1-x86_64.AppImage";
    sha256 = "sha256-N5gdWuxOrIudJx/4nYo4/SKSxakpTFvL4zzByv6Cnug=";
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
  '';
  meta = with pkgs.lib; {
    description = "Helium Browser (AppImage wrapper)";
    homepage = "https://github.com/imputnet/helium-linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}