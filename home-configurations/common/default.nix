{ pkgs, configurationName, ... }:

{
  imports = [
    ../../modules/bash.nix
    ../../modules/direnv.nix

    ../../modules/editors/nvim
    ../../modules/tmux
    ../../modules/git.nix
    ../../modules/fzf.nix
    ../../modules/zoxide.nix
    ../../modules/eza.nix
    ../../modules/bat.nix
    ../../modules/jq.nix
    ../../modules/htop.nix
    ../../modules/trash-cli.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    file
    ncdu
    tealdeer
    nb
    proton-pass-cli
    bruno
  ];

  programs.bash.shellAliases.rb = "nix build .#homeConfigurations.${configurationName}.activationPackage && ./result/activate";

  programs.home-manager.enable = true;
}
