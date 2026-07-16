{ pkgs, ... }:

{
  # Battery-low notifier referenced by pkgs/sway/config's
  # `exec ~/.config/battery-alert/battery-alert`. Not present in the
  # original rice repo (see the script's own comment) - written to match
  # its evident purpose. No-ops on machines with no laptop battery.
  home.file."battery-alert-script" = {
    target = ".config/battery-alert/battery-alert";
    source = ./battery-alert;
    executable = true;
  };

  # Flameshot screenshot config (bound to Mod+Shift+s in pkgs/sway/config).
  # Under Wayland, flameshot defaults to the D-Bus protocol and warns it's
  # not recommended; enabling the grim adapter makes it capture via grim
  # (already on the system) instead, which silences the warning and is the
  # supported path on sway.
  xdg.configFile."flameshot/flameshot.ini".text = ''
    [General]
    useGrimAdapter=true
  '';

  home.packages = with pkgs; [ libnotify ];
}
