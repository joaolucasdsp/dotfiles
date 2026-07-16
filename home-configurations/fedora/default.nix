{ pkgs, username, homeDirectory, ... }:

{
  imports = [
    ../common
    ../../pkgs/readline
    ../../pkgs/base16-shell.nix
    ../../pkgs/ssh-fedora.nix
    ../../pkgs/proton.nix
  ];

  home.packages = with pkgs; [
    pfetch
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
}
