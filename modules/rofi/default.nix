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
}
