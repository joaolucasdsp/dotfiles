{ config, pkgs, prelude, ... }:

with pkgs.vimPlugins;
let
  aliases = {
    v = "nvim";
    nv = "nvim";
  };
in
{
  imports = [
    ./map-leader.nix # TODO: windows

    # ---- Language server protocol ----
    ./plugins/lsp-signature.nix
    ./plugins/lspconfig.nix
    # ./plugins/lsp_lines.nix

    # ./lsp/omnisharp.nix
    ./lsp/csharpls.nix
    ./lsp/go.nix
    ./lsp/erlang.nix
    ./lsp/fsharp.nix
    ./lsp/rust.nix
    # ./lsp/clojure.nix
    ./lsp/elixir.nix
    # ./lsp/godot.nix
    ./lsp/haskell.nix
    # ./lsp/latex.nix
    # ./lsp/lua.nix
    ./lsp/node.nix
    ./lsp/python.nix
    ./lsp/rnix.nix
    ./lsp/ccls.nix
    ./lsp/crystalline.nix
    ./lsp/angular.nix
    ./lsp/ocaml.nix

    # ---- Linting ----
    # ./plugins/nvim-lint.nix

    # ---- General plugins ----
    # ./plugins/typewriter.nix

    # Utils
    # ./plugins/tree-sitter.nix
    ./plugins/nvim-tree.nix
    ./plugins/cmp.nix
    ./plugins/pears.nix

    ./plugins/fzf.nix

    # ./plugins/togglelist.nix
    # ./plugins/closetag.nix
    # ./plugins/neomake.nix
    ./plugins/slash.nix
    ./plugins/vim-test.nix
    # ./plugins/vim-slime.nix

    # Repl
    # ./plugins/conjure.nix

    # Debugging
    # ./plugins/dap.nix
    # ./plugins/dap-ui.nix

    # Git
    ./plugins/gitsigns.nix
    ./plugins/fugitive.nix

    # Aesthetic
    ./colorschemes/onedark.nix
    ./plugins/todo-comments.nix

    # nvim tabs
    # ./plugins/barbar.nix
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
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
      vim-crystal
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
