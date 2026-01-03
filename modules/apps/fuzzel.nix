{ config, pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "DejaVuSansM Nerd Font Mono:size=12";
        dpi-aware = "yes";
        prompt = "❯ ";
        placeholder = "Type to search…";
        show-actions = "no";
        match-mode = "fuzzy";
        terminal = "ghostty";
        launch-prefix = "";
        exit-on-keyboard-focus-loss = "yes";

        width = 80;
        lines = 10;
        line-height = 24;
        horizontal-pad = 1;
        vertical-pad = 1;
        inner-pad = 2;
        anchor = "center";

        password-character = "*";
        filter-desktop = "yes";

        icon-theme = "Adwaita";
        icons-enabled = "no";

        sort-result = "yes";
        match-counter = "yes";

        show-history = "yes";
        history-size = 1000;

        render-workers = 2;

        selection-wrap = "yes";
      };

      colors = {
        background = "1f2134ff";
        text = "c8c8e6ff";
        input = "c8c8e6ff";

        prompt = "4ea1ffff";
        match = "4ea1ffff";

        placeholder = "595959ff";
        selection = "44475aff";
        selection-text = "c8c8e6ff";
        selection-match = "4ea1ffff";

        border = "6c8affff";
        counter = "b4d7ffff";
      };

      border = {
        width = 2;
        radius = 0;
      };

      dmenu = {
        mode = "text";
        exit-immediately-if-empty = "no";
      };

      key-bindings = {
        up = "Up Control+k";
        down = "Down Control+j";
        left = "Left";
        right = "Right";

        accept = "Return KP_Enter";
        cancel = "Escape Control+g";

        delete-prev = "BackSpace";
        delete-next = "Delete";
        delete-line = "Control+u";
        delete-prev-word = "Control+w";

        history-prev = "Alt+p";
        history-next = "Alt+n";

        copy = "Control+c";
        paste = "Control+v";

        toggle-actions = "Tab";
      };

      mouse = {
        enabled = "yes";
        hide-cursor = "yes";
      };

      search = {
        wrap = "yes";
      };

      rendering = {
        use-csd = "no";
      };

      experimental = {
        layer-shell = "yes";
      };
    };
  };
}
