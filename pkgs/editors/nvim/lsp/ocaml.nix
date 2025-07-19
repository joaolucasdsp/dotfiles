{ pkgs, prelude, ... }:

{
  home.packages = with pkgs; [
    ocamlPackages.ocaml-lsp
  ];

  programs.neovim.extraConfig = prelude.mkLuaCode ''
    require('lspconfig').ocamllsp.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        codelens = {
          enable = true,
        },
        inlayHints = {
          enable = true,
        },
      },
    }
  '';
}
