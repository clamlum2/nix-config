{ device, username, ... }:
{
  imports = [
    ./zed.nix
    ./kopuz.nix

    ./terminals
  ]
  ++ (
    if device == "nixos" then
      [
        ./gaming.nix
        ./obs.nix
      ]
    else
      [ ]
  );

  home-manager.users.${username}.imports = [
    ./fuzzel.nix
    ./micro.nix
    ./yazi.nix

    ./bars/quickshell.nix
  ];
}
