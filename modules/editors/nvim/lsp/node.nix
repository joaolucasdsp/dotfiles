{ pkgs, prelude, ... }:

with pkgs;
{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    vim.lsp.config('ts_ls', {
      on_attach = on_attach,
      capabilities = capabilities
    })
    vim.lsp.enable('ts_ls')
  '';
}
