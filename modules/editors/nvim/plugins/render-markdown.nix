{ pkgs, ... }:

let
  render-markdown = {
    plugin = pkgs.vimPlugins.render-markdown-nvim;
    type = "lua";
    config = ''
      require("render-markdown").setup({
        latex = { enabled = false },
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("markdown_reading", {}),
        pattern = "markdown",
        callback = function()
          vim.opt_local.colorcolumn = ""
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
        end,
      })
    '';
  };
in
{
  programs.neovim.plugins = [ render-markdown ];
}
