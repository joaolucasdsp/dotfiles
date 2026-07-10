{ pkgs, prelude, ... }:

let
  lspconfig = {
    plugin = pkgs.vimPlugins.nvim-lspconfig;
    type = "viml";
    config = prelude.mkLuaCode ''
      -- Configure diagnostics (Neovim 0.11+ compatible)
      vim.diagnostic.config({
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          border = "single",
          source = "always",
        },
      })

      -- Add borders to lsp hover and signature popups
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(
        vim.lsp.handlers.hover,
        {
          border = "single"
        }
      )
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {
          border = "single"
        }
      )

      -- This function needs to be global, so that other lsp configs inside
      -- ./lsp will be able to reference it in their setup.
      _G.on_attach = function(client, bufnr)

        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

        vim.wo.signcolumn = 'yes'

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- Updated diagnostic navigation for Neovim 0.11+
        buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<cr>', opts)

        buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        buf_set_keymap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)

        buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)

        buf_set_keymap('n', '<leader>lq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
        buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format { async = true }<cr>", opts)
        buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        buf_set_keymap('n', '<leader>ls', '<cmd>lua vim.lsp.buf.workspace_symbol("")<cr>', opts)
        buf_set_keymap('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
      end

      -- Lsp capabilities
      _G.capabilities = vim.lsp.protocol.make_client_capabilities()

      capabilities.textDocument.codeAction = {
          dynamicRegistration = true,
          codeActionLiteralSupport = {
              codeActionKind = {
                  valueSet = (function()
                      local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
                      table.sort(res)
                      return res
                  end)()
              }
          }
      }

      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.preselectSupport = true
      capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
      capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
      capabilities.textDocument.completion.completionItem.deprecatedSupport = true
      capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
      capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        }
      }

      -- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]
    '';
  };
in
{
  programs.neovim.plugins = [
    lspconfig
  ];
}
