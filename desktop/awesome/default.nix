{ pkgs, username, ... }:

{
    home.file.".config/awesome".source = "/home/codando/dotfiles/desktop/awesome/configs";
}