{ config, pkgs, nixpkgs-unstable, ... }:

let
  unstable = import nixpkgs-unstable {
    system = pkgs.system or "x86_64-linux";
    config.allowUnfree = true;
  };
in

{
  users.extraGroups.docker.members = [ "clamt" ];

  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
  };

  environment.systemPackages = [
    unstable.ollama-cuda
    pkgs.python3
  ];

  networking.firewall.allowedTCPPorts = [ 11434 ];
  networking.firewall.allowedUDPPorts = [ 11434 ];
}