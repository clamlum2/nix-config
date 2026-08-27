{ device, ... }:

if device != "asahi" then
  {
    imports = [ ./ly.nix ];
  }
else
  {
    imports = [ ./greetd.nix ];
  }
