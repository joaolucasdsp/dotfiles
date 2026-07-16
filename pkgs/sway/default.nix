{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
    swaylock
  ];

  # Fedora Sway Spin ships /usr/share/sway/config.d/90-bar.conf, which starts
  # its own waybar via a `bar { swaybar_command waybar }` block. That block is
  # pulled in by the layered-include in our config, so it renders a SECOND
  # waybar on top of the one we start as a systemd user service (pkgs/waybar).
  # layered-include shadows system config.d files with same-named user files,
  # so an (effectively) empty file here suppresses the built-in bar.
  xdg.configFile."sway/config.d/90-bar.conf".text = ''
    # Intentionally empty. Shadows Fedora's /usr/share/sway/config.d/90-bar.conf
    # so it doesn't start a second waybar; ours runs as a systemd user service.
  '';


  # Fedora Sway Spin ships sway as a system package (dnf), already wired
  # into the display manager and PAM/systemd session setup. We manage only
  # the user config here and deliberately don't let home-manager install
  # its own sway (package = null), to avoid two separate sway builds
  # fighting over the session.
  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = null;
    checkConfig = false;
    extraConfig = builtins.readFile ./config;

    # Exports the real session environment (WAYLAND_DISPLAY, etc.) to
    # systemd/D-Bus on startup and defines `sway-session.target`, which is
    # what lets waybar/dunst (started as systemd user services) come up
    # after sway is actually ready.
    systemd = {
      enable = true;
      xdgAutostart = true;
    };
  };
}
