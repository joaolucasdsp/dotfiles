{ pkgs, ... }:

let
  autopairs = {
    plugin = pkgs.vimPlugins.nvim-autopairs;
    type = "lua";
    config = ''
      require("nvim-autopairs").setup()
    '';
  };
in
{
  programs.neovim.plugins = [ autopairs ];
}
