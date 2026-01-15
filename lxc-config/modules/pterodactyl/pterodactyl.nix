{ config, pkgs, ... }:

{
  environment.etc."docker/pterodactyl/docker-compose.yml".source = ../../resources/pterodactyl/pterodactyl-compose.yml;


  systemd.services."pterodactyl-docker-stack" = {
    description = "Pterodactyl Docker Compose Stack";
    wants = [ "network-online.target" "docker.service" ];
    after = [ "network-online.target" "docker.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      WorkingDirectory = "/etc/docker/pterodactyl/";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
    };
  };
}