{ pkgs, ... }:

let
  dap = {
    plugin = pkgs.vimPlugins.nvim-dap;
    type = "lua";
    config = ''
      local dap = require("dap")

      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "''${fileDirname}",
        },
      }

      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        },
      }

      local keymaps = {
        ["<leader>dd"] = { dap.toggle_breakpoint, "Toggle breakpoint" },
        ["<leader>dD"] = {
          function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
          "Set conditional breakpoint",
        },
        ["<leader>dl"] = {
          function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
          "Set log point",
        },
        ["<leader>df"] = { dap.continue, "Start or continue debugging" },
        ["<leader>dj"] = { dap.step_out, "Step out" },
        ["<leader>dk"] = { dap.step_into, "Step into" },
        ["<leader>dr"] = { function() dap.repl.open() end, "Open debug REPL" },
      }

      for lhs, map in pairs(keymaps) do
        vim.keymap.set("n", lhs, map[1], { desc = map[2] })
      end
    '';
  };
in
{
  programs.neovim.plugins = [ dap ];
}
