{ config, pkgs, prelude, ... }:

let
  aliases = {
    v = "nvim";
    nv = "nvim";
  };
in
{
  imports = [
    ./map-leader.nix

    ./plugins/lsp-signature.nix
    ./plugins/lspconfig.nix
    ./plugins/conform.nix

    ./lsp/node.nix
    ./lsp/python.nix
    ./lsp/rust.nix
    ./lsp/ocaml.nix
    ./lsp/go.nix
    ./lsp/omnisharp.nix
    ./lsp/ccls.nix
    ./lsp/elixir.nix
    ./lsp/erlang.nix
    ./lsp/nix.nix

    ./plugins/nvim-tree.nix
    ./plugins/cmp.nix
    ./plugins/pears.nix
    ./plugins/fzf.nix
    ./plugins/slash.nix
    ./plugins/vim-test.nix

    ./plugins/dap.nix
    ./plugins/dap-ui.nix

    ./plugins/gitsigns.nix
    ./plugins/fugitive.nix

    ./colorschemes/onedark.nix
    ./plugins/todo-comments.nix
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withRuby = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      editorconfig-vim
      vim-polyglot
      targets-vim
      vim-commentary
      vim-repeat
      vim-sensible
      vim-surround
      vim-tmux-navigator
      nvim-web-devicons
      nvim-dap
      copilot-vim
      omnisharp-extended-lsp-nvim
      csharpls-extended-lsp-nvim
    ];

    extraPackages = with pkgs; [
      xclip
    ];

    extraConfig = builtins.readFile ./init.vim;
  };

  programs.bash.shellAliases = aliases;
}
