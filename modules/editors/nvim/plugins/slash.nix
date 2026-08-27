{ pkgs, ... }:

let
  slash = {
    plugin = pkgs.vimPlugins.vim-slash;
    type = "viml";
    config = ''
      noremap <plug>(slash-after) zz
    '';
  };
in
{
  programs.neovim.plugins = [ slash ];
}
