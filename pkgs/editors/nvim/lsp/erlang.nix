{ pkgs, prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    vim.lsp.config('erlangls', {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable('erlangls')
  '';
}
