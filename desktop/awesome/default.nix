{ pkgs, username, ... }:

{
  home-manager.users.${username} = {
    imports = [
      ../../services/flameshot.nix
    ];

    home.packages = with pkgs; [
      dmenu
      rofi
      arandr
    ];

    home.file.".config/awesome".source = "/home/joaop/dotfiles/desktop/awesome/configs";
  };
}

