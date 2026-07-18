{
  pkgs,
  self,
  username,
  inputs,
  nixpkgs-stable,
  ...
}:

let
  stable = import nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in

{
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.systemPackages = [
    stable.moonlight-qt
    inputs.zed-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.skhd.enable = true;
  services.skhd.skhdConfig = ''
    cmd + shift - space : ${
      inputs.zed-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default
    }/bin/zed-launcher
  '';

  system.primaryUser = username;

  home-manager.users.${username} = {
    home.stateVersion = "26.05";
    home.file.".hushlogin".text = "";
  };

  homebrew = {
    enable = true;

    casks = [
      "wine@staging"
    ];
  };
}
