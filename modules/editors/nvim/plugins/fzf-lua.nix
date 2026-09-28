{ pkgs, ... }:

let
  fzf-lua = {
    plugin = pkgs.vimPlugins.fzf-lua;
    type = "lua";
    config = ''
      local fzf = require("fzf-lua")

      fzf.setup({
        fzf_opts = { ["--exact"] = true },
        keymap = {
          fzf = { true, ["ctrl-a"] = "select-all" },
        },
        actions = {
          files = {
            true,
            ["ctrl-q"] = fzf.actions.file_sel_to_qf,
            ["ctrl-x"] = fzf.actions.file_split,
          },
        },
        grep = {
          hidden = true,
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --glob=!.git -e",
        },
      })

      fzf.register_ui_select()

      local pickers = {
        ["<leader>."] = { "git_files", "Find git-tracked files" },
        ["<leader>;"] = { "live_grep", "Grep the project" },
        ["<leader>/"] = { "lines", "Search lines in open buffers" },
        ["<leader>,"] = { "buffers", "Find open buffers" },
        ["<leader>ff"] = { "files", "Find files" },
        ["<leader>fc"] = { "git_commits", "Find git commits" },
        ["<leader>fh"] = { "helptags", "Find help tags" },
        ["<leader>fm"] = { "manpages", "Find man pages" },
        ["<leader>fk"] = { "keymaps", "Find keymaps" },
      }

      for lhs, picker in pairs(pickers) do
        vim.keymap.set("n", lhs, "<cmd>FzfLua " .. picker[1] .. "<cr>", { desc = picker[2] })
      end
    '';
  };
in
{
  programs.neovim.plugins = [ fzf-lua ];
  home.packages = with pkgs; [
    fzf
    fd
    ripgrep
  ];
}
