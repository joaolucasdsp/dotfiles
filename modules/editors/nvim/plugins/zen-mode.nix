{ pkgs, ... }:

let
  zen-mode = {
    plugin = pkgs.vimPlugins.zen-mode-nvim;
    type = "lua";
    config = ''
      require("zen-mode").setup({
        window = {
          options = {
            number = false,
            relativenumber = false,
            signcolumn = "no",
            cursorline = false,
            colorcolumn = "",
          },
        },
        plugins = {
          options = { laststatus = 0 },
          gitsigns = { enabled = true },
          tmux = { enabled = true },
        },
      })

      vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle zen mode" })
    '';
  };
in
{
  programs.neovim.plugins = [ zen-mode ];
}
