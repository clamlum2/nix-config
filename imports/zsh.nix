{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    zsh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];


  home.file.".zshrc".text = ''

    export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
    ZSH_THEME="custom"

    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


    plugins=(git)
    source $ZSH/oh-my-zsh.sh

    alias nrt="sudo rsync -av --exclude='.git' --exclude='README.md' --exclude='install.sh' ~/nix-config/ /etc/nixos/ && sudo nixos-rebuild test && hyprshade on extravibrance";
    alias nrs="sudo rsync -av --exclude='.git' --exclude='README.md' --exclude='install.sh' ~/nix-config/ /etc/nixos/ && sudo nixos-rebuild switch && hyprshade on extravibrance";
    alias updatenix="sh <(curl https://raw.githubusercontent.com/clamlum2/nix-config/refs/heads/main/install.sh)";
    alias cdnix="cd ~/nix-config/";
    alias codenix="code ~/nix-config/";

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

     if [[ "$TERM" != "xterm-256color" ]]; then
      fastfetch --config "/etc/nixos/resources/fastfetch/ssh.jsonc"
    else
      fastfetch --config "/etc/nixos/resources/fastfetch/groups.jsonc"
    fi

    source ~/.oh-my-zsh/custom/themes/custom.zsh-theme
  '';

  home.file.".oh-my-zsh/custom/themes/custom.zsh-theme".text = ''
    PROMPT="%F{cyan}%n@%f"
    PROMPT+="%{$fg[blue]%}%M "
    PROMPT+="%{$fg[cyan]%}%~%  "
    PROMPT+="%(?:%{$fg[green]%}%1{➜%} :%{$fg[red]%}%1{➜%} )%{$reset_color%}"

    RPROMPT='$(git_prompt_info)'

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}git:(%{$fg[blue]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}) %{$fg[yellow]%}%1{✗%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%})"
  '';
}
