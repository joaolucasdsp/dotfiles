{
  config,
  pkgs,
  username,
  homeDirectory,
  ...
}:

{
  imports = [
    ../common
    ../../pkgs/readline
    ../../pkgs/base16-shell.nix
    ../../pkgs/ssh-fedora.nix
    ../../pkgs/proton.nix
    ../../pkgs/sway
    ../../pkgs/kitty
    ../../pkgs/waybar
    ../../pkgs/dunst
    ../../pkgs/rofi
    ../../pkgs/theme
    ../../pkgs/extras
    ../../pkgs/music
    ../../pkgs/spicetify
  ];

  home.packages = with pkgs; [
    pfetch
    spotify-player
    claude-code
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;

  # Standalone home-manager on Fedora: without this, graphical sessions
  # started outside a login shell (app launchers, sway `exec`, systemd/D-Bus
  # activation) don't inherit the Nix profile's PATH or XDG_DATA_DIRS, so
  # Nix-installed GUI apps (e.g. proton-vpn) fail to launch or don't show up
  # in launchers at all, even though they run fine from a terminal.
  targets.genericLinux.enable = true;
  systemd.user.sessionVariables.PATH = "${config.home.profileDirectory}/bin:$PATH";
}
