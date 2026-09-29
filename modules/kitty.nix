{ ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    settings = {
      window_padding_width = 8;
      confirm_os_window_close = 0;
      cursor_shape = "beam";
      enable_audio_bell = "no";
      scrollback_lines = 10000;

      foreground = "#D4BE98";
      background = "#32302F";
      selection_foreground = "none";
      selection_background = "#504945";
      cursor = "#D4BE98";
      cursor_text_color = "#32302F";
      url_color = "#7DAEA3";
      active_border_color = "#A89984";
      inactive_border_color = "#665C54";
      active_tab_foreground = "#32302F";
      active_tab_background = "#A89984";
      inactive_tab_foreground = "#DDC7A1";
      inactive_tab_background = "#5B534D";

      color0 = "#665C54";
      color8 = "#665C54";
      color1 = "#EA6962";
      color9 = "#EA6962";
      color2 = "#A9B665";
      color10 = "#A9B665";
      color3 = "#D8A657";
      color11 = "#D8A657";
      color4 = "#7DAEA3";
      color12 = "#7DAEA3";
      color5 = "#D3869B";
      color13 = "#D3869B";
      color6 = "#89B482";
      color14 = "#89B482";
      color7 = "#D4BE98";
      color15 = "#D4BE98";
    };
  };
}
