{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.tuigreet
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "tuigreet --cmd ${pkgs.niri}/bin/niri-session -r --theme 'border=white;text=white;prompt=white;time=white;action=white;button=white;container=black;input=white'";
        user = "greeter";
      };
    };
  };
}
