{ pkgs, lib, username, homeDirectory, ... }:

let
  shellConfig = {
    initExtra = ''
      if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';
  };
in
{
  imports = [
    ../common
    ../../pkgs/readline
    ../../pkgs/base16-shell.nix
    ../../pkgs/ssh-wsl.nix
  ];

  home.packages = with pkgs; [
    bandwhich
    pfetch
  ];

  programs.bash = shellConfig;

  home.username = username;
  home.homeDirectory = homeDirectory;
}
