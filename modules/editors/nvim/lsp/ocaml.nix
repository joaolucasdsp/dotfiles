{ prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    vim.lsp.config('ocamllsp', {
      on_attach = on_attach,
      capabilities = capabilities,
    })
    vim.lsp.enable('ocamllsp')
  '';
}
