{ pkgs, ... }:

{
  # Proton desktop suite. Linux-only: none of these packages build on Darwin.
  #
  # NOTE: proton-vpn is intentionally NOT installed from nixpkgs. The VPN client
  # is installed from Fedora's official package (dnf) so it integrates cleanly
  # with the system NetworkManager/WireGuard stack; the Nix build fought with
  # the host NM side. The apps below are self-contained GUIs with no such
  # system coupling, so they stay on Nix.
  home.packages = with pkgs; [
    proton-pass
    protonmail-desktop
    proton-authenticator
  ];
}
