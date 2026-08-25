{
  config,
  pkgs,
  username,
  device,
  ...
}:

{
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  home-manager.users.${username} = {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        image = config.vars.wallpaperPath;
        effect-blur = "5x1";

        indicator-radius = 40;
        indicator-thickness = 8;
        indicator-idle-visible = false;
      };
    };

    services.swayidle = {
      enable = true;
      events = {
        lock = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      };
      timeouts = [ ] ++ (if device == "asahi" then [
        { timeout = 300; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
        { timeout = 310; command = "${pkgs.systemd}/bin/systemctl suspend"; }
      ] else []);
    };
  };
}
