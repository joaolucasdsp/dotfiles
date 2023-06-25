{ pkgs, prelude, ... }:

{
  programs.neovim.extraConfig = prelude.mkLuaCode ''
    require('lspconfig').crystalline.setup {
      on_attach = on_attach,
      capabitilies = capabitilies
    }
  '';
}
