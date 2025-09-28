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
      nrt = "sudo nixos-rebuild test && hyprshade on extravibrance";
      nrs = "sudo nixos-rebuild switch && hyprshade on extravibrance";
      cdnix = "cd /etc/nixos/";
      codenix = "code /etc/nixos/";
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

      function nrs() {
        CONFIG_DIR="$HOME/nix-config"
        GIT_REMOTE="origin"
        GIT_BRANCH="main"

        if [ -z "$1" ]; then
          echo "Usage: nrs \"commit message\""
          return 1
        fi

        COMMIT_MSG="$1"

        cd "$CONFIG_DIR" || { echo "Config dir not found!"; return 1; }

        sudo rsync -av --exclude='.git' --exclude='README.md' "$CONFIG_DIR/" /etc/nixos/

        sudo nixos-rebuild switch
        
        if [ $? -eq 0 ]; then
          git add .
          git commit -m "$COMMIT_MSG"
          git push "$GIT_REMOTE" "$GIT_BRANCH"
          echo "NixOS rebuild and config push successful!"
        else
          echo "NixOS rebuild failed; not pushing to GitHub."
          return 1
        fi
      }
    '';
  };

  # Custom theme file
  home.file.".oh-my-zsh/custom/themes/custom.zsh-theme".text = ''
    PROMPT="%F{cyan}%n@%f"
    PROMPT+="%{$fg[blue]%}%M "
    PROMPT+="%{$fg[cyan]%}%~%  "
    PROMPT+="%(?:%{$fg[green]%}%1{➜%} :%{$fg[red]%}%1{➜%} ) %{$reset_color%}"

    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}git:(%{$fg[red]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
  '';
}
