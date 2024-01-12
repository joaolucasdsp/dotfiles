{ pkgs, username, ... }:

{
  imports = [
    ../../services/flameshot.nix
  ];

  home.packages = with pkgs; [
    dmenu
    rofi
    arandr
  ];

  home.file.".config/awesome".source = "/home/${username}/dotfiles/desktop/awesome/configs";
}

