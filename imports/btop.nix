{ config, pkgs, ... }:

{
  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings = {
      color_theme = "custom";
      theme_background = false;
    };
    themes.custom = ''
      theme[main_bg]="#0d1520"
      theme[main_fg]="#FFFFFF"
      theme[title]="#57f7fc"
      theme[hi_fg]="#579599"
      theme[selected_bg]="#57f7fc"
      theme[selected_fg]="#000000"
      theme[inactive_fg]="#313850"
      theme[graph_text]="#FFFFFF"
      theme[meter_bg]="#313850"
      theme[proc_misc]="#57f7fc"
      theme[cpu_box]="#57f7fc"
      theme[mem_box]="#579599"
      theme[net_box]="#57f7fc"
      theme[proc_box]="#57f7fc"
      theme[div_line]="#313850"

      theme[temp_start]="#313850"
      theme[temp_mid]="#579599"
      theme[temp_end]="#57f7fc"

      theme[cpu_start]="#313850"
      theme[cpu_mid]="#579599"
      theme[cpu_end]="#57f7fc"

      theme[free_start]="#313850"
      theme[free_mid]="#579599"
      theme[free_end]="#57f7fc"
      theme[cached_start]="#579599"
      theme[cached_mid]="#57f7fc"
      theme[cached_end]="#aef7fb"
      theme[available_start]="#313850"
      theme[available_mid]="#579599"
      theme[available_end]="#57f7fc"
      theme[used_start]="#313850"
      theme[used_mid]="#57f7fc"
      theme[used_end]="#579599"

      theme[download_start]="#313850"
      theme[download_mid]="#579599"
      theme[download_end]="#57f7fc"
      theme[upload_start]="#313850"
      theme[upload_mid]="#57f7fc"
      theme[upload_end]="#579599"

      theme[process_start]="#57f7fc"
      theme[process_mid]="#57f7fc"
      theme[process_end]="#57f7fc"
    '';
  };
}