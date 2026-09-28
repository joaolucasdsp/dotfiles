{ pkgs, ... }:

let
  bufferline = {
    plugin = pkgs.vimPlugins.bufferline-nvim;
    type = "lua";
    config = ''
      local bufremove = require("mini.bufremove")
      bufremove.setup()

      local function delete(bufnr) bufremove.delete(bufnr) end

      require("bufferline").setup({
        options = {
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          close_command = delete,
          right_mouse_command = delete,
          offsets = { { filetype = "NvimTree" } },
        },
      })

      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Go to buffer " .. i })
      end
      vim.keymap.set("n", "<leader>bd", delete, { desc = "Delete buffer and keep window" })
    '';
  };
in
{
  programs.neovim.plugins = [
    bufferline
    pkgs.vimPlugins.mini-bufremove
  ];
}
