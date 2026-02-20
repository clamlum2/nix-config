{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.tuigreet
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "tuigreet --cmd /run/current-system/sw/bin/niri-session -r --theme 'border=blue;text=blue;prompt=blue;time=blue;action=blue;button=blue;container=black;input=blue'";
        user = "greeter";
      };
    };
  };
}
