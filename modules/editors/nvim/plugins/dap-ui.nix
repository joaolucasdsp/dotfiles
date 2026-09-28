{ pkgs, ... }:

let
  dap-ui = {
    plugin = pkgs.vimPlugins.nvim-dap-ui;
    type = "lua";
    config = ''
      require("dapui").setup()

      vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle debug UI" })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dap_repl_completion", {}),
        pattern = "dap-repl",
        callback = function() require("dap.ext.autocompl").attach() end,
      })
    '';
  };
in
{
  programs.neovim.plugins = [ dap-ui ];
}
