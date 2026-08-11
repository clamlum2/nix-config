{ pkgs, inputs, device, ... }:

if device == "nixos" then
{
  environment.systemPackages = [
    inputs.custom-kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
else let
  system = pkgs.stdenv.hostPlatform.system;
  kopuzSrc = inputs.kopuz;
  kopuzBin = inputs.kopuz.packages.${system}.default;

  kopuzApp = pkgs.stdenvNoCC.mkDerivation {
    pname = "kopuz-app-bundle";
    version = "unstable";
    dontUnpack = true;

    nativeBuildInputs = [ pkgs.imagemagick pkgs.libicns ];

    installPhase = ''
      appdir="$out/Applications/Kopuz.app/Contents"
      mkdir -p "$appdir/MacOS" "$appdir/Resources"

      cat > "$appdir/MacOS/kopuz" <<EOF
      #!/bin/sh
      exec "${kopuzBin}/bin/kopuz" "\$@"
      EOF
      chmod +x "$appdir/MacOS/kopuz"

      cp ${kopuzSrc}/crates/kopuz/assets/icon.icns "$appdir/Resources/AppIcon.icns"
      cp ${kopuzSrc}/crates/kopuz/Info.plist "$appdir/Info.plist"
    '';
  };
in
{
  nix.settings = {
    substituters = [ "https://kopuz.cachix.org" ];
    trusted-public-keys = [
      "kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="
    ];
  };

  environment.systemPackages = [
    kopuzApp
  ];
}
