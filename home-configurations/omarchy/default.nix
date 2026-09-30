{ config, pkgs, ... }:

# Omarchy (Arch + Hyprland). Hyprland, the bar, notifications and theming stay
# with Omarchy; this profile brings the shell/editor tooling and rofi.
{
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

  # pass-cli keeps its session key in the kernel keyring by default, which is
  # wiped on reboot. Omarchy's gnome-keyring (unlocked at login) keeps it across
  # boots instead, so a single `pass-cli login` is enough and this profile
  # doesn't need proton-pass-login.nix and its sops-stored token.
  home.sessionVariables.PROTON_PASS_LINUX_KEYRING = "dbus";
  systemd.user.services.proton-pass-agent = {
    # Keep retrying while the keyring is still coming up at login.
    Unit.StartLimitIntervalSec = 0;
    Service = {
      Environment = [ "PROTON_PASS_LINUX_KEYRING=dbus" ];
      RestartSec = 5;
    };
  };

  # ssh-keygen (git commit signing) reads SSH_AUTH_SOCK, not the ssh config.
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.ssh/proton-pass-agent.sock";

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
  targets.genericLinux.enable = true;
}
