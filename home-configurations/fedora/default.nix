{ config
, pkgs
, username
, homeDirectory
, ...
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

  targets.genericLinux.enable = true;
  systemd.user.sessionVariables.PATH = "${config.home.profileDirectory}/bin:$PATH";
}
