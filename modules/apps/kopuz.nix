{
  system,
  kopuz,
  ...
}:

{
  nix.settings = {
    substituters = [ "https://kopuz.cachix.org" ];
    trusted-public-keys = [
      "kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="
    ];
  };

  environment.systemPackages = [
    kopuz.packages.${system}.default
  ];
}
