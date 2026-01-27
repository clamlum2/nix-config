{ config, ... }:

{
  environment.etc."docker/mediaserver/docker-compose.yml".source = ../../resources/mediaserver/mediaserver-compose.yml;

  networking.hostName = "mediaserver";

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ ];
  };
}