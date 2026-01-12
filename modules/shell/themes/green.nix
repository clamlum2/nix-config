{ config, ... }:

{
  home.file.".oh-my-zsh/custom/themes/custom.zsh-theme".text = ''
    PROMPT="%F{#4CAF50}%n@%f"
    PROMPT+="%F{#81C784}%M%f "
    PROMPT+="%F{#A5D6A7}%~%f  "
    PROMPT+="%(?:%F{#4CAF50}%1{➜%} :%F{#E53935}%1{➜%} )%{$reset_color%}"

    RPROMPT='$(git_prompt_info)'

    ZSH_THEME_GIT_PROMPT_PREFIX="%F{#4CAF50}git:(%F{#A5D6A7}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
    ZSH_THEME_GIT_PROMPT_DIRTY="%F{#4CAF50}) %F{#FFB86B}%1{✗%}%f"
    ZSH_THEME_GIT_PROMPT_CLEAN="%F{#4CAF50})%f"
  '';
}