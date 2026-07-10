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
    shellAliases = {
      rb = "nix build .#homeConfigurations.wsl.activationPackage && result/activate";
    };
  };
in
{
  imports = [
    # Shell
    ../../pkgs/bash.nix
    ../../pkgs/readline # GNU readline input
    ../../pkgs/base16-shell.nix # Shell themes
    ../../pkgs/direnv.nix

    # Core CLI
    ../../pkgs/editors/nvim
    ../../pkgs/tmux # Terminal multiplexer
    ../../pkgs/git.nix
    ../../pkgs/ssh.nix # SSH config + Bitwarden agent bridge
    ../../pkgs/fzf.nix # Fuzzy finder
    ../../pkgs/zoxide.nix # Jump directories
    ../../pkgs/eza.nix # ls alternative
    ../../pkgs/bat.nix # File previewer
    ../../pkgs/jq.nix # Work with json
    ../../pkgs/htop.nix # Process viewer
    ../../pkgs/trash-cli.nix # Safer rm
  ];

  home.packages = with pkgs; [
    ripgrep # File content finder
    fd # File finder
    file # Shows info about files
    ncdu # Curses interface for `du`
    bandwhich # Network inspector
    tealdeer # TLDR of man pages
    pfetch # System information
    nb # Note taking
  ];

  programs.bash = shellConfig;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = homeDirectory;
}
