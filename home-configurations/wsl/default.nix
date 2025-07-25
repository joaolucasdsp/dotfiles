{ pkgs, lib, username, homeDirectory, ... }:

let
  shellConfig = {
    initExtra = "
      . ~/.nix-profile/etc/profile.d/nix.sh
    ";
    shellAliases = {
      rb = "nix build .#homeConfigurations.wsl.activationPackage && result/activate";
    };
  };
in
{
  imports = [
    ../../utils/scripts

    # CLI
    ../../pkgs/base16-shell.nix # Different shell themes
    ../../pkgs/zoxide.nix # Jump directories
    ../../pkgs/bash.nix # Shell
    ../../pkgs/editors/nvim
    ../../pkgs/readline # GNU readline input
    ../../pkgs/git.nix
    ../../pkgs/tmux # Terminal multiplexer
    ../../pkgs/fzf.nix # Fuzzy finder
    ../../pkgs/eza.nix # ls alternative
    ../../pkgs/trash-cli.nix # Safer rm
    ../../pkgs/htop.nix # Process viewer
    #../../pkgs/keychain.nix # Ssh key caching
    ../../pkgs/gpg.nix
    ../../pkgs/jq.nix # Work with json
    ../../pkgs/bat.nix # File previewer
    ../../pkgs/newsboat.nix # News reader
    ../../pkgs/tiny.nix # TUI IRC client
    ../../pkgs/direnv.nix

    #../../services/gpg-agent.nix
  ];

  home.packages = with pkgs; [
    # CLI
    bandwhich # Network inspector
    tealdeer # TLDR of man pages
    ripgrep # File content finder
    fd # File finder
    ncdu # Curses interface for `du`
    file # Shows info about files
    neofetch # Shows system information
    pfetch # Smaller neofetch

    # take notes
    nb

    ffmpeg
    espeak-classic
    mpv
  ];

  programs.bash = shellConfig;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "${username}";
  home.homeDirectory = homeDirectory;
}
