{ pkgs, ... }:

let
  conform = {
    plugin = pkgs.vimPlugins.conform-nvim;
    type = "lua";
    config = ''
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          typescript = { "prettier" },
          javascript = { "prettier" },
          html = { "prettier" },
          htmlangular = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          json = { "prettier" },
          ocaml = { "ocamlformat" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })

      vim.keymap.set("n", "<leader>lf", function()
        conform.format({ async = true, lsp_format = "fallback" })
      end, { desc = "Format buffer" })
    '';
  };
in
{
  programs.neovim.plugins = [ conform ];
}
