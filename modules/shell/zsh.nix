{ config, pkgs, lib, ... }:

{
  imports = [ ./themes/nix-shell.nix ];

  home.packages = [
    pkgs.zsh
    pkgs.oh-my-zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.zsh-you-should-use
    pkgs.zsh-nix-shell

    pkgs.lsd
    pkgs.bat
    pkgs.zoxide
  ];

  home.file.".zshrc".text = ''
    export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
    export JAVA_HOME="${pkgs.jdk25}"

    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
    source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

    plugins=(git)
    source $ZSH/oh-my-zsh.sh

    alias ls="lsd --group-directories-first -A"
    alias cat="bat -p"
    alias cd="z"

    alias nrs="sh ~/nix-config/scripts/rebuild.sh -a switch"
    alias nrt="sh ~/nix-config/scripts/rebuild.sh -a test"
    alias nrb="time sh ~/nix-config/scripts/rebuild.sh -a build"
    alias ncg="sudo nix-collect-garbage -d"

    i () {
      if [[ $# -eq 0 ]]; then
        nix-shell
      else
        nix-shell -p "$@"
      fi
    }

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

    eval "$(zoxide init zsh)"

    if [[ -n "$IN_NIX_SHELL" ]]; then
      source ~/.oh-my-zsh/custom/themes/nix-shell.zsh-theme
    else
      source ~/.oh-my-zsh/custom/themes/custom.zsh-theme
      cd ~
    fi
  '';
}
