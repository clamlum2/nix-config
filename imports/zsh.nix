{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "colorize" ];
      theme = "custom";
    };

    shellAliases = {
      nrt = "sudo rsync -av --exclude='.git' --exclude='README.md' --exclude='install.sh' ~/nix-config/ /etc/nixos/ && sudo nixos-rebuild test && hyprshade on extravibrance";
      nrs = "sudo rsync -av --exclude='.git' --exclude='README.md' --exclude='install.sh' ~/nix-config/ /etc/nixos/ && sudo nixos-rebuild switch && hyprshade on extravibrance";
      updatenix = "sh <(curl https://raw.githubusercontent.com/clamlum2/nix-config/refs/heads/main/install.sh)";
      cdnix = "cd ~/nix-config/";
      codenix = "code ~/nix-config/";
    };

    history.size = 10000;

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
      ];
    };

    initContent = lib.mkOrder 550 ''
      export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
      if [[ "$TERM" != "xterm-kitty" ]]; then
        fastfetch --config "/etc/nixos/resources/fastfetch/ssh.jsonc"
      else
        fastfetch --config "/etc/nixos/resources/fastfetch/groups.jsonc"
      fi

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
    '';
  };

  # Custom theme file
  home.file.".oh-my-zsh/custom/themes/custom.zsh-theme".text = ''
    PROMPT="%F{cyan}%n@%f"
    PROMPT+="%{$fg[blue]%}%M "
    PROMPT+="%{$fg[cyan]%}%~%  "
    PROMPT+="%(?:%{$fg[green]%}%1{➜%} :%{$fg[red]%}%1{➜%} )%{$reset_color%}"

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
  '';
}
