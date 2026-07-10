{ pkgs, prelude, ... }:

let
  pears = {
    plugin = pkgs.vimPlugins.pears-nvim;
    type = "viml";
    config = prelude.mkLuaCode "require('pears').setup()";
  };
in
{
  programs.neovim.plugins = [ pears ];
}
