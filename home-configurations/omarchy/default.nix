{ config, pkgs, ... }:

# Omarchy (Arch + Hyprland). Hyprland, the bar, notifications and theming stay
# with Omarchy; this profile brings the shell/editor tooling and rofi.
{
  # No proton-pass-login.nix yet: log in once with `pass-cli login` until the
  # age key is on this machine.
  imports = [
    ../linux
    ../../modules/rofi
  ];

  # Keep Omarchy's environment (OMARCHY_PATH, its bin dir, mise, starship...).
  # It is sourced here, ahead of the dotfiles aliases, because Omarchy defines
  # functions (e.g. ga) that an already-defined alias of the same name breaks.
  programs.bash.bashrcExtra = ''
    [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap
    [[ $- == *i* ]] && source "''${OMARCHY_PATH:-/usr/share/omarchy}/default/bash/rc"
  '';

  # ssh-keygen (git commit signing) reads SSH_AUTH_SOCK, not the ssh config.
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.ssh/proton-pass-agent.sock";

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  targets.genericLinux.enable = true;
}
