{ ... }:

{
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech PRO X 2 SE]
    MatchName=Logitech PRO X 2 SE
    ModelBouncingKeys=1

    [Glorious Model O]
    MatchName=Glorious Model O
    ModelBouncingKeys=1
  '';
}
