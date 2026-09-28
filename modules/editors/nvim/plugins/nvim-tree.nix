{ pkgs, ... }:

let
  nvim-tree = {
    plugin = pkgs.vimPlugins.nvim-tree-lua;
    type = "lua";
    config = ''
      require("nvim-tree").setup({
        filters = { git_ignored = false },
        update_focused_file = { enable = true },
        view = { width = { min = 30 } },
        renderer = {
          highlight_git = "name",
          indent_markers = { enable = true },
          icons = {
            show = {
              folder_arrow = false,
              git = false,
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
    '';
  };
in
{
  programs.neovim.plugins = [ nvim-tree ];
}
