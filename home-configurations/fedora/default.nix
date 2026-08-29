{ config, pkgs, ... }:

{
  imports = [
    ../linux
    ../../modules/proton.nix
    ../../modules/sway
    ../../modules/kitty.nix
    ../../modules/waybar
    ../../modules/dunst.nix
    ../../modules/rofi
    ../../modules/theme.nix
    ../../modules/extras
    ../../modules/music
    ../../modules/spicetify.nix
  ];

  home.packages = with pkgs; [
    pfetch
    spotify-player
    claude-code
  ];

  targets.genericLinux.enable = true;
  systemd.user.sessionVariables.PATH = "${config.home.profileDirectory}/bin:$PATH";
}
