{ pkgs, prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    require('lspconfig').csharp_ls.setup{
      on_attach = on_attach,
      capabilities = capabilities,
      handlers = {
        ["textDocument/definition"] = require('csharpls_extended').handler,
      },
    }
  '';
}
