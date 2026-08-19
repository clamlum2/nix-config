{ pkgs, inputs, device, username, ... }:
let
  configDir = if device == "macbook" then
    "Library/Application Support/com.temidaradev.kopuz"
  else ".config/kopuz";

  configFile = ''
    discord_presence = false
    settings_layout = "TopBar"
    theme = "ayu-mirage"
    ui_style = "Vaxry"
  '';
in
if device == "nixos" then
{
  environment.systemPackages = [
    inputs.custom-kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.users.${username}.home.file."${configDir}/settings.toml".text = configFile;
}
else let
  system = pkgs.stdenv.hostPlatform.system;
  kopuzSrc = inputs.kopuz;
  kopuzBin = inputs.kopuz.packages.${system}.default;

  kopuzApp = pkgs.stdenvNoCC.mkDerivation {
    pname = "kopuz-app-bundle";
    version = "unstable";
    dontUnpack = true;

    installPhase = ''
      appdir="$out/Applications/Kopuz.app/Contents"
      mkdir -p "$appdir/MacOS" "$appdir/Resources"

      cp ${kopuzBin}/bin/kopuz "$appdir/MacOS/kopuz"
      chmod +x "$appdir/MacOS/kopuz"

      chmod +w "$appdir"

      cp ${kopuzSrc}/crates/kopuz/assets/icon.icns "$appdir/Resources/Kopuz.icns"
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

  home-manager.users.${username}.home.file."${configDir}/settings.toml".text = configFile;
}
