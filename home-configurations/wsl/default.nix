{ pkgs, ... }:

{
  imports = [
    ../linux
    ../../modules/proton-pass-login.nix
  ];

  home.packages = with pkgs; [
    bandwhich
    pfetch
  ];

  programs.bash.initExtra = ''
    if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
  '';
}
