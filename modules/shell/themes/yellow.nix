{ ... }:

{
  home.file.".oh-my-zsh/custom/themes/custom.zsh-theme".text = ''
    PROMPT="%F{#FFEA00}%n@%f"
    PROMPT+="%F{#FFD54F}%m%f "
    PROMPT+="%F{#FFF59D}%~%f  "
    PROMPT+="%(?:%F{#FFEA00}%1{➜%} :%F{#E06C75}%1{➜%} )%{$reset_color%}"

    RPROMPT='$(git_prompt_info)'

    ZSH_THEME_GIT_PROMPT_PREFIX="%F{#FFEA00}git:(%F{#FFF59D}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
    ZSH_THEME_GIT_PROMPT_DIRTY="%F{#FFEA00}) %F{#FFB86B}%1{✗%}%f"
    ZSH_THEME_GIT_PROMPT_CLEAN="%F{#FFEA00})%f"
  '';
}
