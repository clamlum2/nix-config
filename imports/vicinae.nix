{ pkgs , ... }:

{
  services.vicinae = {
    enable = true;
    autoStart = true;
  };
}