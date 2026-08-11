{ device, username, ... }:
{
  imports = [
    ./android.nix
    ./zed.nix
    ./kopuz.nix

    ./terminals
  ]
  ++ (
    if device == "nixos" then
      [
        ./gaming.nix
        ./obs.nix
        ./resolve.nix
        ./openrgb.nix
        ./discord.nix
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
