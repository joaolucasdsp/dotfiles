{ pkgs, lib, ... }:

let
  gruvbox-material = {
    plugin = pkgs.vimPlugins.gruvbox-material;
    type = "lua";
    config = ''
      vim.g.gruvbox_material_background = "soft"
      vim.cmd.colorscheme("gruvbox-material")
    '';
  };
in
{
  programs.neovim.plugins = lib.mkBefore [ gruvbox-material ];
}
