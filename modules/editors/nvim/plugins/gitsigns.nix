{ pkgs, ... }:

let
  gitsigns = {
    plugin = pkgs.vimPlugins.gitsigns-nvim;
    type = "lua";
    config = ''
      local gitsigns = require("gitsigns")

      local function nav(direction, key)
        return function()
          if vim.wo.diff then
            vim.cmd.normal({ key, bang = true })
          else
            gitsigns.nav_hunk(direction)
          end
        end
      end

      local function visual_range(action)
        return function() action({ vim.fn.line("."), vim.fn.line("v") }) end
      end

      local function blame_full() gitsigns.blame_line({ full = true }) end

      local keymaps = {
        { "n", "]c", nav("next", "]c"), "Next hunk" },
        { "n", "[c", nav("prev", "[c"), "Previous hunk" },
        { "n", "<leader>hs", gitsigns.stage_hunk, "Stage or unstage hunk" },
        { "v", "<leader>hs", visual_range(gitsigns.stage_hunk), "Stage or unstage selected lines" },
        { "n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk" },
        { "v", "<leader>hr", visual_range(gitsigns.reset_hunk), "Reset selected lines" },
        { "n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer" },
        { "n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer" },
        { "n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk" },
        { "n", "<leader>hb", blame_full, "Blame line" },
        { "n", "<leader>gm", blame_full, "Blame line" },
        { "n", "<leader>hd", gitsigns.diffthis, "Diff against index" },
        { "n", "<leader>hD", function() gitsigns.diffthis("~") end, "Diff against last commit" },
        { "n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle inline blame" },
        { "n", "<leader>td", gitsigns.preview_hunk_inline, "Preview hunk inline" },
        { { "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk" },
      }

      gitsigns.setup({
        current_line_blame_opts = { delay = 100 },
        current_line_blame_formatter = "<author>, <author_time:%d-%m-%Y> - <summary>",
        on_attach = function(bufnr)
          for _, map in ipairs(keymaps) do
            vim.keymap.set(map[1], map[2], map[3], { buffer = bufnr, desc = map[4] })
          end
        end,
      })
    '';
  };
in
{
  programs.neovim.plugins = [ gitsigns ];
}
