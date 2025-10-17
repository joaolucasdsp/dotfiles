{ pkgs, prelude, ... }:

with pkgs;
{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    require('lspconfig').ts_ls.setup{
      on_attach = on_attach,
      capabilities = capabilities
    }
  '';
}
