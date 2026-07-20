{ pkgs, configurationName, ... }:

{
  imports = [
    ../../modules/free-claude-code.nix

    # Shell
    ../../pkgs/bash.nix
    ../../pkgs/direnv.nix

    # Core CLI
    ../../pkgs/editors/nvim
    ../../pkgs/tmux
    ../../pkgs/git.nix
    ../../pkgs/fzf.nix
    ../../pkgs/zoxide.nix
    ../../pkgs/eza.nix
    ../../pkgs/bat.nix
    ../../pkgs/jq.nix
    ../../pkgs/htop.nix
    ../../pkgs/trash-cli.nix
  ];

  programs.free-claude-code.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    file
    ncdu
    tealdeer
    nb
  ];

  programs.bash.shellAliases.rb =
    "nix build .#homeConfigurations.${configurationName}.activationPackage && ./result/activate";

  programs.home-manager.enable = true;
}
