{ pkgs, ... }:

{
  home.file."battery-alert-script" = {
    target = ".config/battery-alert/battery-alert";
    source = ./battery-alert;
    executable = true;
  };

  xdg.configFile."flameshot/flameshot.ini".text = "";

  home.packages = with pkgs; [ libnotify ];
}
