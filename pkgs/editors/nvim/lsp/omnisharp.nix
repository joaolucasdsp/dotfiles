{ pkgs, prelude, ... }:

with pkgs;
{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    local pid = vim.fn.getpid()
    local omnisharp_bin = "${omnisharp-roslyn}/bin/OmniSharp"

    vim.lsp.config('omnisharp', {
      cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
      on_attach = on_attach,
      capabilities = capabilities,
      handlers = {
        -- Use extended handler with error handling
        ["textDocument/definition"] = function(err, result, ctx, config)
          local success, extended_err = pcall(function()
            require('omnisharp_extended').handler(err, result, ctx, config)
          end)
          
          -- If it fails, fall back to default handler
          if not success then
            vim.notify("Metadata navigation failed, using standard handler", vim.log.levels.WARN)
            vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
          end
        end,
      },
      -- Enable formatting (Visual Studio style)
      settings = {
        FormattingOptions = {
          -- Use Visual Studio formatting defaults
          EnableEditorConfigSupport = true,
          OrganizeImports = false,
        },
        RoslynExtensionsOptions = {
          EnableAnalyzersSupport = true,
          EnableImportCompletion = true,
          AnalyzeOpenDocumentsOnly = false,
        },
      },
    })
    vim.lsp.enable('omnisharp')
  '';
}
