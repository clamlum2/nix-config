self: super:

let
  orig = super.vesktop;
  makeWrapper = super.makeWrapper;
  stdenv = super.stdenv;
in
{
  vesktop-with-wayland = stdenv.mkDerivation {
    pname = "vesktop";
    version = "wrapped-" + (orig.version or "0");

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [];

    installPhase = ''
      mkdir -p $out/bin $out/share/applications

      ${makeWrapper}/bin/makeWrapper ${orig}/bin/vesktop $out/bin/vesktop \
        --add-flags "--ozone-platform=wayland"
      chmod +x $out/bin/vesktop

      if [ -f ${orig}/share/applications/vesktop.desktop ]; then
        mkdir -p $out/share/applications
        cp ${orig}/share/applications/vesktop.desktop $out/share/applications/

        substituteInPlace $out/share/applications/vesktop.desktop \
          --replace 'Exec=vesktop %U' "Exec=$out/bin/vesktop %U" || true
        substituteInPlace $out/share/applications/vesktop.desktop \
          --replace 'Exec=vesktop' "Exec=$out/bin/vesktop" || true
        substituteInPlace $out/share/applications/vesktop.desktop \
          --replace 'Exec=/run/current-system/sw/bin/vesktop %U' "Exec=$out/bin/vesktop %U" || true
        substituteInPlace $out/share/applications/vesktop.desktop \
          --replace 'Exec=/run/current-system/sw/bin/vesktop' "Exec=$out/bin/vesktop" || true
      fi
    '';

    meta = orig.meta or { description = "vesktop wrapped with --ozone-platform=wayland"; };
  };
}