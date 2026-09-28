{ pkgs, ... }:

let
  lspconfig = {
    plugin = pkgs.vimPlugins.nvim-lspconfig;
    type = "lua";
    config = ''
      local severity = vim.diagnostic.severity

      vim.diagnostic.config({
        virtual_text = false,
        signs = {
          text = {
            [severity.ERROR] = "",
            [severity.WARN] = "",
            [severity.HINT] = "",
            [severity.INFO] = "",
          },
        },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = { source = "if_many" },
      })

      local servers = {
        angularls = {},
        ccls = {},
        cssls = {},
        elixirls = { cmd = { "elixir-ls" } },
        erlangls = {},
        gopls = {},
        html = { filetypes = { "html", "htmlangular" } },
        jedi_language_server = {},
        nil_ls = {},
        ocamllsp = {},
        roslyn = {
          settings = {
            ["csharp|completion"] = {
              dotnet_show_completion_items_from_unimported_namespaces = true,
            },
            ["csharp|background_analysis"] = {
              dotnet_analyzer_diagnostics_scope = "fullSolution",
              dotnet_compiler_diagnostics_scope = "fullSolution",
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              diagnostics = { disabled = { "unresolved-proc-macro" } },
            },
          },
        },
        ts_ls = {},
      }

      for name, config in pairs(servers) do
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      local keymaps = {
        { "K", function() vim.lsp.buf.hover({ border = "single" }) end, "Show hover documentation" },
        { "<C-k>", function() vim.lsp.buf.signature_help({ border = "single" }) end, "Show signature help" },
        { "gd", vim.lsp.buf.definition, "Go to definition" },
        { "gD", vim.lsp.buf.declaration, "Go to declaration" },
        { "gi", vim.lsp.buf.implementation, "Go to implementation" },
        { "gr", "<cmd>FzfLua lsp_references<cr>", "List references", nowait = true },
        { "<leader>D", vim.lsp.buf.type_definition, "Go to type definition" },
        { "<leader>ld", vim.diagnostic.open_float, "Show line diagnostics" },
        { "<leader>lq", vim.diagnostic.setloclist, "List diagnostics in location list" },
        { "<leader>lr", vim.lsp.buf.rename, "Rename symbol" },
        { "<leader>la", vim.lsp.buf.code_action, "Code action" },
        { "<leader>ls", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "Search workspace symbols" },
      }

      local group = vim.api.nvim_create_augroup("lsp_config", {})

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          for _, map in ipairs(keymaps) do
            vim.keymap.set("n", map[1], map[2], { buffer = args.buf, desc = map[3], nowait = map.nowait })
          end
          vim.wo.signcolumn = "yes"
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        pattern = "*.go",
        callback = function(args)
          local client = vim.lsp.get_clients({ bufnr = args.buf, name = "gopls" })[1]
          if not client then
            return
          end
          local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
          params.context = { only = { "source.organizeImports" } }
          local response = client:request_sync("textDocument/codeAction", params, 1000, args.buf)
          for _, action in ipairs(response and response.result or {}) do
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
            end
          end
        end,
      })
    '';
  };
in
{
  programs.neovim = {
    plugins = [
      lspconfig
      pkgs.vimPlugins.roslyn-nvim
    ];

    extraPackages = with pkgs; [
      angular-language-server
      nil
      roslyn-ls
      typescript-language-server
      vscode-langservers-extracted
    ];
  };
}
