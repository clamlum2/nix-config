{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.nginx
    pkgs.mariadb
    pkgs.redis
    pkgs.docker
    pkgs.git
    pkgs.unzip
    pkgs.curl
    pkgs.nodejs
    pkgs.yarn
    pkgs.php
    pkgs.phpPackages.pdo_mysql
    pkgs.phpPackages.mbstring
    pkgs.phpPackages.zip
    pkgs.phpPackages.gd
    pkgs.phpPackages.curl
  ];

  services.nginx.enable = true;
  services.phpfpm.enable = true;
  services.mariadb.enable = true;
  services.redis.enable = true;
  services.docker.enable = true;

  users.users.pterodactyl = {
    isNormalUser = true;
    extraGroups = [ "nginx" "docker" ];
  };

  systemd.services.pterodactyl-panel = {
    description = "Pterodactyl Panel";
    wants = [ "mysql.service" "php-fpm.service" "redis.service" ];
    after = [ "mysql.service" "php-fpm.service" "redis.service" ];
    serviceConfig.ExecStart = "${pkgs.php}/bin/php /srv/pterodactyl/artisan serve --host=0.0.0.0 --port=8080";
    serviceConfig.User = "pterodactyl";
    serviceConfig.WorkingDirectory = "/srv/pterodactyl";
    restart = "always";
  };

  environment.etc."srv/pterodactyl".source = ./pterodactyl;
}