{ config, pkgs, ... }:

{
  environment.etc."docker/vaultwarden/docker-compose.yml".source = ../../resources/vaultwarden/vaultwarden-compose.yml;
}