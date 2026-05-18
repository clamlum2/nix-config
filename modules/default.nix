{ device, ... }:

{
  imports =
    [ ]
    ++ (
      if device == "nixos" || device == "laptop" then
        [
          ./configuration.nix
          ./pkgs.nix
        ]
      else
        [ ]
    );

  home-manager.users.clamt.imports = [
    ./home.nix
  ];
}
