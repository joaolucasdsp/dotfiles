{ pkgs, prelude, ... }:

{
  # `nil` is the maintained Nix language server (rnix-lsp is archived).
  programs.neovim.extraPackages = [ pkgs.nil ];

  programs.neovim.extraConfig = prelude.mkLuaCode ''
    require('lspconfig').nil_ls.setup{
      on_attach = on_attach,
      capabilities = capabilities
    }
  '';
}
