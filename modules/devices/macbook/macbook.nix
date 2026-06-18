{ self, username, ... }:

{
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  home-manager.users.${username} = {
    home.stateVersion = "26.05";
    home.file.".hushlogin".text = "";
  };
}
