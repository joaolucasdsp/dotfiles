{ inputs, pkgs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  # Adapted from https://github.com/LoneWolf4713/new-wave's Spotify
  # theming (Bloom Dark Mono + Adblock + Full Screen extensions), via
  # https://github.com/Gerg-L/spicetify-nix since spicetify patches an
  # installed Spotify client in place - the flake builds a pre-patched
  # Spotify package instead of mutating one at runtime, which is the only
  # way to do this declaratively under Nix. It installs Spotify itself;
  # don't add pkgs.spotify separately anywhere else.
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.bloom;
    colorScheme = "darkmono";
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      fullScreen
    ];
  };
}
