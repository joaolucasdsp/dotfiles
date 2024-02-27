{ pkgs, username, ... }:

{
  imports = [
    ../../services/flameshot.nix
  ];

  home.packages = with pkgs; [
    dmenu
    rofi
    arandr
    polybar
  ];

  home.file.".config".source = "/home/${username}/dotfiles/desktop/awesome-joepigott/dots";
}

