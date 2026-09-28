{ pkgs, ... }:

let
  claudecode = {
    plugin = pkgs.vimPlugins.claudecode-nvim;
    type = "lua";
    config = ''
      require("claudecode").setup({
        log_level = "warn",
        terminal = { provider = "none" },
      })

      vim.keymap.set("x", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })
      vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current file to Claude" })
      vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept Claude diff" })
      vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny Claude diff" })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("claudecode_tree", {}),
        pattern = "NvimTree",
        callback = function(args)
          vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", { buffer = args.buf, desc = "Add file to Claude" })
        end,
      })
    '';
  };
in
{
  programs.neovim.plugins = [ claudecode ];
}
