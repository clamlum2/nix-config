{ config, ... }:

{
  home.file.".oh-my-zsh/custom/themes/custom.zsh-theme".text = ''
    PROMPT="%F{#B76CFF}%n@%f"
    PROMPT+="%F{#8A6CFF}%M%f "
    PROMPT+="%F{#CDB4FF}%~%f  "
    PROMPT+="%(?:%F{#B76CFF}%1{➜%} :%F{#E06C75}%1{➜%} )%{$reset_color%}"

    RPROMPT='$(git_prompt_info)'

    ZSH_THEME_GIT_PROMPT_PREFIX="%F{#B76CFF}git:(%F{#2B1642}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
    ZSH_THEME_GIT_PROMPT_DIRTY="%F{#B76CFF}) %F{#FFB86B}%1{✗%}%f"
    ZSH_THEME_GIT_PROMPT_CLEAN="%F{#B76CFF})%f"
  '';

  home.file.".config/fastfetch/ssh.jsonc".source = ../../../resources/fastfetch/purple.jsonc;
}