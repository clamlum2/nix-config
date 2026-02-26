# Should not be nessecary anymore.

self: super:

let
  orig = super.vesktop;
  makeWrapper = super.makeWrapper;
  stdenv = super.stdenv;
in
{
  vesktop-with-wayland = stdenv.mkDerivation {
    pname = "vesktop-with-wayland";
    version = "wrapped-" + (orig.version or "0");

    src = null;
    dontUnpack = true;
    phases = [ "installPhase" ];

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [];

    installPhase = ''
      set -euo pipefail

      mkdir -p "$out/bin" "$out/share/applications"

      if [ -x "${orig}/bin/vesktop" ]; then
        src_exec="${orig}/bin/vesktop"
      elif [ -x "${orig}/libexec/vesktop" ]; then
        src_exec="${orig}/libexec/vesktop"
      elif [ -d "${orig}/bin" ] && [ "$(ls -A "${orig}/bin" || true)" ]; then
        src_exec="$(ls -d "${orig}/bin/"* | head -n1)"
      else
        echo "error: could not find vesktop executable in ${orig}" >&2
        exit 1
      fi

      flags="--enable-features=UseOzonePlatform --ozone-platform=wayland --use-gl=angle --use-angle=gl --enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder --enable-features=VaapiIgnoreDriverChecks,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,UseMultiPlaneFormatForHardwareVideo"

      makeWrapper "$src_exec" "$out/bin/vesktop" \
        --add-flags "$flags"
      chmod +x "$out/bin/vesktop"

      if [ -f "${orig}/share/applications/vesktop.desktop" ]; then
        mkdir -p "$out/share/applications"
        cp "${orig}/share/applications/vesktop.desktop" "$out/share/applications/"
        execfile="$out/share/applications/vesktop.desktop"

        orig_exec_line="$(grep '^Exec=' "${orig}/share/applications/vesktop.desktop" | head -n1 || true)"
        if [ -n "$orig_exec_line" ]; then
          orig_exec="$(printf '%s' "$orig_exec_line" | sed 's/^Exec=//')"

          rest="$(printf '%s' "$orig_exec" | cut -s -d' ' -f2-)"

          if [ -n "$rest" ]; then
            new_exec="$out/bin/vesktop $flags $rest"
          else
            new_exec="$out/bin/vesktop $flags"
          fi

          awk -v new="Exec=$new_exec" 'BEGIN{repl=0} /^Exec=/ && !repl {print new; repl=1; next} {print}' "$execfile" > "$execfile.tmp"
          mv "$execfile.tmp" "$execfile"
        fi
      fi
    '';

    meta = orig.meta or { description = "vesktop wrapped with --ozone-platform=wayland"; };
  };
}