{ pkgs, username, homeDirectory, ... }:

{
  imports = [
    ../common
    ../../pkgs/base16-shell.nix
    ../../pkgs/ssh-macos.nix
  ];

  home.packages = with pkgs; [
    coreutils
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
}
