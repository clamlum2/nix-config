{ device, username, ... }:

{
  imports = [
    ./fonts.nix
  ]
  ++ (
    if device == "nixos" || device == "laptop" then
      [
        ./audio.nix
        ./gtk.nix
        ./qt.nix
        ./libinput.nix
      ]
    else
      [ ]
  );

  home-manager.users.${username}.imports =
    [ ]
    ++ (
      if device == "nixos" || device == "laptop" then
        [
          ./icons.nix
          ./mako.nix
        ]
      else
        [ ]
    );
}
