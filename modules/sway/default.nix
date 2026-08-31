{ pkgs, ... }:

{
  home.packages = with pkgs; [
    brightnessctl
  ];

  xdg.configFile."sway/config.d/90-bar.conf".text = ''
    # Intentionally empty. Shadows Fedora's /usr/share/sway/config.d/90-bar.conf
    # so it doesn't start a second waybar; ours runs as a systemd user service.
  '';

  wayland.windowManager.sway = {
    enable = true;
    package = null;
    config = null;
    checkConfig = false;
    extraConfig = builtins.readFile ./config;

    systemd = {
      enable = true;
      xdgAutostart = true;
    };
  };
}
