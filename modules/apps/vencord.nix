{
  config,
  pkgs,
  lib,
  ...
}:

let
  vencordInstaller = pkgs.stdenv.mkDerivation rec {
    pname = "vencord-installer";
    version = "1.4.0";
    src = pkgs.fetchurl {
      url = "https://github.com/Vencord/Installer/releases/download/v${version}/VencordInstallerCli-linux";
      hash = "sha256-gVkXp5ORpEJgIrOVzB2OQa6AEw7auYy/vgj7vmfNKyg=";
    };
    dontUnpack = true;
    installPhase = "install -Dm755 $src $out/bin/VencordInstaller";
  };

  installScript = pkgs.writeShellScript "vencord-install" ''
      ${vencordInstaller}/bin/VencordInstaller -install -location "$HOME/.config/discord" \
        >/dev/null 2>&1
      rc=$?
      if [ "$rc" -eq 0 ]; then
        echo "Vencord: install OK"
      else
        echo "Vencord: install FAILED (exit $rc)"
      fi
      true

      ${vencordInstaller}/bin/VencordInstaller -install-openasar -location "$HOME/.config/discord" \
        >/dev/null 2>&1
      rc=$?
      if [ "$rc" -eq 0 ]; then
        echo "OpenASAR: install OK"
      else
        echo "OpenASAR: install FAILED (exit $rc)"
      fi
      true
  '';
in
{
  system.activationScripts.vencord-install = lib.stringAfter [ "users" ] ''
    for user in ${
      lib.escapeShellArgs (lib.attrNames (lib.filterAttrs (_: u: u.isNormalUser) config.users.users))
    }; do
      home=$(${pkgs.getent}/bin/getent passwd "$user" | cut -d: -f6)
      [ -d "$home" ] || continue
      HOME="$home" ${pkgs.util-linux}/bin/runuser -u "$user" -- ${installScript} || true
    done
  '';
}
