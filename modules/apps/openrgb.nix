{ pkgs, lib, username, ... }:
let
  asrockControllerSrc = pkgs.fetchFromGitHub {
    owner = "VirulentArc";
    repo = "openrgb-asrock-rx9070xt-steel-legend-controller";
    rev = "main";
    hash = "sha256-RHO3Cux6oknXNjPZipR66kLdy3vP/qH7Ao0ANEembTo=";
  };

  openrgbWithAsrock = pkgs.openrgb.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      cp -r ${asrockControllerSrc}/Controllers/ASRockRX9070XTGPUController Controllers/
      chmod -R u+w Controllers/ASRockRX9070XTGPUController
    '';
  });
in
{
  services.hardware.openrgb.enable = true;
  systemd.services.openrgb.enable = lib.mkForce false;

  environment.systemPackages = [ openrgbWithAsrock ];

  boot.kernelModules = [ "i2c-dev" ];
  hardware.i2c.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", GROUP="i2c", MODE="0660"
  '';

  users.groups.i2c = {};
  users.users.${username}.extraGroups = [ "i2c" ];

}
