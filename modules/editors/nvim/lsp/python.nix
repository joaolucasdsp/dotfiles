{ pkgs, prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    vim.lsp.config('jedi_language_server', {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150
      }
    })
    vim.lsp.enable('jedi_language_server')
  '';
}
