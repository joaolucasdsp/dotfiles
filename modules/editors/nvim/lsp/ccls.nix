{ pkgs, prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    vim.lsp.config('ccls', {
      on_attach = on_attach,
      capabilities = capabilities
    })
    vim.lsp.enable('ccls')
  '';
}
