{ config, pkgs, ... }:

{
  imports = [ ./pterodactyl-service.nix ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  services.pterodactyl = {
    enable = true;
    nginxVhost = "localhost";
    user = "pterodactyl";
    dataDir = "/srv/pterodactyl";
    redisName = "pterodactis";
  };
}