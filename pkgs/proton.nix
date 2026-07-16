{ pkgs, ... }:

{
  # Proton desktop suite. Linux-only: none of these packages build on Darwin.
  #
  # `proton-vpn` talks to the *system* NetworkManager over D-Bus to bring
  # up WireGuard/OpenVPN connections, so it needs `NetworkManager` running on
  # the host (Fedora Workstation ships it enabled by default). The Nix build
  # covers the client itself, not the kernel/NM side.
  home.packages = with pkgs; [
    proton-vpn
    proton-pass
    protonmail-desktop
    proton-authenticator
  ];
}
