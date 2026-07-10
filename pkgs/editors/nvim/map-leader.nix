{ pkgs, lib, ... }:

let
  leader-mappings = {
    plugin = pkgs.writeText "dummy" "";
    type = "viml";
    config = ''
      let mapleader = " "
      let maplocalleader = ","
    '';
  };
in
{
  programs.neovim.plugins = lib.mkBefore [ leader-mappings ];
}
