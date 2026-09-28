{ pkgs, ... }:

let
  trouble = {
    plugin = pkgs.vimPlugins.trouble-nvim;
    type = "lua";
    config = ''
      require("trouble").setup({
        focus = true,
        auto_preview = true,
        warn_no_results = false,
        open_no_results = true,
        win = { size = 0.3 },
      })
    '';
  };
in
{
  programs.neovim.plugins = [ trouble ];
}
