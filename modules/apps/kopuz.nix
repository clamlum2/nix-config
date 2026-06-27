{ pkgs, inputs, ... }:

let
  kopuz = inputs.kopuz.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  nix.settings = {
    substituters = [ "https://kopuz.cachix.org" ];
    trusted-public-keys = [
      "kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="
    ];
  };

  environment.systemPackages = [
    kopuz
  ];
}
