{ pkgs, ... }:

{
  wsl.wslConf.network.hostname = "wsl";
  networking.hostName = "wsl";

  wsl = {
    enable = true;
    defaultUser = "clamt";
  };

  services.openssh.enable = true;
  users.users."clamt".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH/sXIx+I7BCq6T4QfiEWqvh+E1d9+y4CrTijURf5Wsq clamt"
  ];

  programs.nix-ld.enable = true;

  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = [
    pkgs.git
  ];
}
