{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
    wmctrl
    libnotify
  ];

  xdg.configFile.rofi = {
    source = ./rofi;
    recursive = true;
  };

  home.file.".local/share/fonts/feather.ttf".source = ./fonts/feather.ttf;
}
