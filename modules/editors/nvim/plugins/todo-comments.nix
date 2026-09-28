{ pkgs, ... }:

let
  todo-comments = {
    plugin = pkgs.vimPlugins.todo-comments-nvim;
    type = "lua";
    config = ''
      require("todo-comments").setup()
      vim.keymap.set("n", "<leader>pt", "<cmd>TodoQuickFix<cr>", { desc = "List project TODOs" })
    '';
  };
in
{
  programs.neovim.plugins = [ todo-comments ];
}
