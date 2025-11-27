{ config, pkgs, lib, ... }:

let
  zsh-shift-select = pkgs.fetchFromGitHub {
    owner = "jirutka";
    repo = "zsh-shift-select";
    rev = "master";
    sha256 = "sha256-ekA8acUgNT/t2SjSBGJs2Oko5EB7MvVUccC6uuTI/vc=";
  };
in
{
  home.packages = [
    pkgs.zsh
    pkgs.oh-my-zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-you-should-use

    pkgs.fastfetch
    pkgs.lsd
    pkgs.bat
    pkgs.zoxide
  ];

  home.file.".zshrc".text = ''
    export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"

    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${zsh-shift-select}/zsh-shift-select.plugin.zsh
    source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh

    plugins=(git)
    source $ZSH/oh-my-zsh.sh

    # Aliases now call the scripts directly; the scripts handle syncing and
    # calling hyprshade so flags (eg. --upgrade) are forwarded correctly.
    alias nrt="sh /etc/nixos/scripts/rebuild.sh -a test"
    alias nrs="sh /etc/nixos/scripts/rebuild.sh -a switch"
    alias updatenix="sh <(curl https://raw.githubusercontent.com/clamlum2/nix-config/main/scripts/update.sh)"
    alias cdnix="cd ~/nix-config/"
    alias codenix="code ~/nix-config/"
    alias ls="lsd --group-directories-first -A"
    alias cat="bat -p"
    alias cd="z"
    alias spotifyinstall="sh /etc/nixos/resources/spotify.sh"

    function sshkey() {
      if [[ -n $SSH_CONNECTION ]]; then
          echo "Not running copy command over SSH."
          cat ~/.ssh/id_ed25519.pub
      else
          cat ~/.ssh/id_ed25519.pub | wl-copy
          echo "Public key copied to clipboard."
      fi
    }

    function prox() {
      if [[ -n $1 ]]; then
          ssh root@192.168.1.$1
      else
          echo "Usage: prox <last octet of remote machine ip>"
      fi
    }

    if [[ "$TERM" = "xterm-ghostty" ]]; then
      fastfetch -c ~/.config/fastfetch/groups
    else
      fastfetch -c ~/.config/fastfetch/ssh
    fi

    source ~/.oh-my-zsh/custom/themes/custom.zsh-theme

    eval "$(zoxide init zsh)"
  '';

  home.file.".config/fastfetch/groups.jsonc".source = ../../resources/fastfetch/groups.jsonc;

  home.file.".ssh/id_ed25519.pub".source = ./../../resources/ssh/id_ed25519.pub;
}
