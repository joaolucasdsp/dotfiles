{ pkgs, prelude, ... }:

{
  programs.neovim.extraPackages = [ pkgs.nil ];

  programs.neovim.extraConfig = prelude.mkLuaCode ''
    vim.lsp.config('nil_ls', {
      on_attach = on_attach,
      capabilities = capabilities
    })
    vim.lsp.enable('nil_ls')
  '';
}
