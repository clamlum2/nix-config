{ device, username, ... }:

{
  imports =
    [ ]
    ++ (
      if device == "nixos" || device == "laptop" then
        [
          ./configuration.nix
          ./pkgs.nix
          ./variables.nix
        ]
      else
        [ ]
    );

  home-manager.users.${username}.imports = [
    ./home.nix
  ];
}
