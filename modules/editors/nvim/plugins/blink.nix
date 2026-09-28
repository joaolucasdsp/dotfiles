{ pkgs, ... }:

let
  blink = {
    plugin = pkgs.vimPlugins.blink-cmp;
    type = "lua";
    config = ''
      require("blink.cmp").setup({
        keymap = {
          preset = "none",
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<CR>"] = { "accept", "fallback" },
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<C-d>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        },
        signature = { enabled = true },
      })
    '';
  };
in
{
  programs.neovim.plugins = [ blink ];
}
