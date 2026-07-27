{ device, username, ... }:
{
  imports = [
    ./android.nix
    ./zed.nix

    ./terminals
  ]
  ++ (
    if device == "nixos" then
      [
        ./gaming.nix
        ./obs.nix
        ./kopuz.nix
        ./resolve.nix
      ]
    else
      [ ]
  );

  home-manager.users.${username}.imports =
    [ ]
    ++ (
      if device == "nixos" || device == "laptop" then
        [
          ./fuzzel.nix
          ./micro.nix
          ./yazi.nix

          ./bars/quickshell.nix
        ]
      else
        [ ]
    );
}
