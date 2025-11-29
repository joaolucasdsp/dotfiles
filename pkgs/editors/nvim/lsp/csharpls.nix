{ pkgs, prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    local lspconfig = require('lspconfig')
    
    lspconfig.csharp_ls.setup{
      on_attach = function(client, bufnr)
        -- Disable LSP formatting in favor of csharpier
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        
        -- Call the global on_attach if it exists
        if on_attach then
          on_attach(client, bufnr)
        end
      end,
      capabilities = capabilities,
      -- Use default handlers - extended handlers have issues with metadata in Nix
      -- If you need metadata navigation, consider using OmniSharp instead
      -- Root dir must find .sln or .csproj
      root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", ".git"),
      -- Critical: Enable solution-wide analysis
      init_options = {
        AutomaticWorkspaceInit = true
      },
    }
  '';
}
