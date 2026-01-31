{ config, ... }:

{
  environment.etc."docker/mediaserver/docker-compose.yml".source = ../../resources/mediaserver/mediaserver-compose.yml;

  networking.hostName = "mediaserver";

  networking.firewall = {
    allowedTCPPorts = [ 5055 7878 8080 8989 9696 ];
    allowedUDPPorts = [ ];
  };

  users.users.chris = {
    isNormalUser = true;
    description = "chris";
    packages = with pkgs; [];
  };

  services.samba = {
    enable = true;
    settings = {
      media = {
        path = "/mnt/drive/media";
        browseable = true;
        "read only" = false;
        "guest ok" = false;
        "valid users" = " chris ";
      };
    };
  };
}