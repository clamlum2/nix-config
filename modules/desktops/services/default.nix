{ device, ... }:

{
  imports = [
    ./fonts.nix
  ]
  ++ (
    if device == "nixos" || device == "laptop" then
      [
        ./audio.nix
        ./gtk.nix
      ]
    else
      [ ]
  );

  home-manager.users.clamt.imports =
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
