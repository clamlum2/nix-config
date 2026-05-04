{ pkgs, ... }:

{
  home.packages = [
    pkgs.yazi
  ];

  programs.yazi = {
    enable = true;
    settings = {
    };
  };

  home.file.".zshrc".text = ''
    function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      command yazi "$@" --cwd-file="$tmp"
      IFS= read -r -d $'\0' cwd < "$tmp"
      [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
      rm -f -- "$tmp"
    }
  '';
}
