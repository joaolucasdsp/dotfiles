{ pkgs, prelude, ... }:

let
  conform = {
    plugin = pkgs.vimPlugins.conform-nvim;
    type = "viml";
    config = prelude.mkLuaCode ''
      require("conform").setup({
        formatters_by_ft = {
          -- C# formatting with OmniSharp (Visual Studio style) via LSP
          -- No external formatter needed - OmniSharp handles it
          
          -- TypeScript/JavaScript formatting with prettier
          typescript = { "prettier" },
          javascript = { "prettier" },
          
          -- Angular HTML templates
          html = { "prettier" },
          
          -- CSS/SCSS
          css = { "prettier" },
          scss = { "prettier" },
          
          -- JSON
          json = { "prettier" },

          -- OCaml formatting
          ocaml = { "ocamlformat" },
        },
        
        -- Format on save
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })

      -- Override the default <leader>lf to use conform with LSP fallback
      vim.keymap.set("n", "<leader>lf", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    '';
  };
in
{
  programs.neovim.plugins = [ conform ];
}
