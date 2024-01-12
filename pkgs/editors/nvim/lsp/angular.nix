{ pkgs, prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    require('lspconfig').angularls.setup{
      on_attach = on_attach,
      capabilities = capabilities,
    }
  '';
}
