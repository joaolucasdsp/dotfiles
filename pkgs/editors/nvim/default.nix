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

    # ---- Language server protocol ----
    ./plugins/lsp-signature.nix
    ./plugins/lspconfig.nix
    ./plugins/conform.nix # Formatting

    ./lsp/node.nix # TypeScript / JavaScript
    ./lsp/python.nix
    ./lsp/rust.nix
    ./lsp/go.nix
    ./lsp/omnisharp.nix # C# / .NET
    ./lsp/ccls.nix # C / C++
    ./lsp/elixir.nix
    ./lsp/erlang.nix
    ./lsp/nix.nix

    # ---- Utils ----
    ./plugins/nvim-tree.nix
    ./plugins/cmp.nix
    ./plugins/pears.nix
    ./plugins/fzf.nix
    ./plugins/slash.nix
    ./plugins/vim-test.nix

    # ---- Debugging ----
    ./plugins/dap.nix
    ./plugins/dap-ui.nix

    # ---- Git ----
    ./plugins/gitsigns.nix
    ./plugins/fugitive.nix

    # ---- Aesthetic ----
    ./colorschemes/onedark.nix
    ./plugins/todo-comments.nix
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    # Preserve pre-26.05 behavior (providers enabled) now that the defaults flipped.
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
