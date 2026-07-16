{ pkgs, ... }:

{
  # Adapted from https://github.com/LoneWolf4713/new-wave's dunstrc. The
  # original had the [global]/[urgency_*] sections defined twice (merged by
  # dunst's ini parser); folded into one section each here since Nix attrs
  # can't have duplicate keys anyway. Also swapped the hardcoded
  # /usr/bin/rofi and google-chrome-stable paths for PATH-relative lookups,
  # and the missing "flattrcolor" icon theme for the Flat-Remix one we
  # install (pkgs/waybar's sibling, see the sway GTK theme settings).
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Blue-Dark";
      size = "scalable";
    };
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        indicate_hidden = true;
        shrink = true;
        transparency = 0;
        separator_height = 3;
        padding = 12;
        horizontal_padding = 12;
        frame_width = 3;
        frame_color = "#89B4FA";
        separator_color = "auto";
        sort = true;
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        format = "<b>%s </b>\\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        icon_position = "left";
        max_icon_size = 128;
        sticky_history = true;
        history_length = 20;
        dmenu = "${pkgs.rofi}/bin/rofi -show run -p dunst:";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        force_xinerama = false;
      };

      experimental.per_monitor_dpi = false;

      urgency_low = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        timeout = 10;
      };
      urgency_normal = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        timeout = 10;
      };
      urgency_critical = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        frame_color = "#FAB387";
        timeout = 0;
      };
    };
  };
}
