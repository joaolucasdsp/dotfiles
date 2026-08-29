{ pkgs, prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    vim.lsp.config('elixirls', {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { "elixir-ls" }
    })
    vim.lsp.enable('elixirls')
  '';
}
