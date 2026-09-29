{ config, ... }:

{
  xdg.configFile."niri/config.kdl".text = builtins.readFile ./config.kdl + ''

    cursor {
        xcursor-theme "${config.home.pointerCursor.name}"
        xcursor-size ${toString config.home.pointerCursor.size}
    }
  '';
}
