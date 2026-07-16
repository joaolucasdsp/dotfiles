{ ... }:

{
  # Adapted from https://github.com/LoneWolf4713/new-wave. Dropped the
  # custom/weather module (the rice's script has a literal placeholder for
  # lat/lon that was never filled in) and a few dead/unused module configs
  # (wlr/taskbar, hyprland/workspaces, memory, cpu) that weren't referenced
  # by modules-left/center/right anyway.
  programs.waybar = {
    enable = true;
    settings = [ (builtins.fromJSON (builtins.readFile ./config.json)) ];
    style = ./style.css;

    # Started via systemd, gated on sway's session target
    # (wayland.windowManager.sway.systemd.enable, see pkgs/sway).
    systemd.enable = true;
  };
}
