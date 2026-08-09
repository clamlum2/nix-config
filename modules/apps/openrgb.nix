{ pkgs, lib, username, ... }:

let
  openrgbPlugin = pkgs.stdenv.mkDerivation {
    pname = "openrgb-asrock-rx9070xt-steel-legend-plugin";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "VirulentArc";
      repo = "openrgb-asrock-rx9070xt-steel-legend-plugin";
      rev = "main";
      hash = "sha256-SPqjjuCgbBmQLaJx4hbYXV0hzbtseUyYGLiI2mHbwfE=";
    };

    nativeBuildInputs = with pkgs; [
      qt6.qmake
      qt6.qttools
    ];

    buildInputs = [ pkgs.qt6.qtbase ];

    dontWrapQtApps = true;

    buildPhase = ''
      runHook preBuild

      cp -r . "$TMPDIR/plugin"
      chmod -R u+w "$TMPDIR/plugin"
      cd "$TMPDIR/plugin"

      substituteInPlace ASRockRX9070XTPlugin.cpp \
        --replace-fail 'bus->bus_id != 7' 'bus->bus_id != 8'

      OPENRGB_ROOT="${pkgs.openrgb.src}" \
        qmake6 OpenRGBASRockRX9070XTPlugin.pro

      make -j"$NIX_BUILD_CORES"

      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/lib
      cp "$TMPDIR/plugin/build/libOpenRGBASRockRX9070XTPlugin.so" \
        $out/lib/
    '';
  };
in

{
  services.hardware.openrgb.enable = true;
  # systemd.services.openrgb.enable = lib.mkForce false;

  environment.systemPackages = [ pkgs.openrgb ];

  boot.kernelModules = [ "i2c-dev" ];
  hardware.i2c.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", GROUP="i2c", MODE="0660"
  '';

  users.groups.i2c = {};
  users.users.${username}.extraGroups = [ "i2c" ];

  home-manager.users.${username}.home.file.".config/OpenRGB/plugins/libOpenRGBASRockRX9070XTPlugin.so".source =
    "${openrgbPlugin}/lib/libOpenRGBASRockRX9070XTPlugin.so";

  system.activationScripts.openrgbRootPlugin = ''
    mkdir -p /root/.config/OpenRGB/plugins
    ln -sf ${openrgbPlugin}/lib/libOpenRGBASRockRX9070XTPlugin.so \
      /root/.config/OpenRGB/plugins/libOpenRGBASRockRX9070XTPlugin.so
  '';
}
