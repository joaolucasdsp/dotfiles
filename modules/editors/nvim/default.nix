{ pkgs, ... }:

let
  aliases = {
    v = "nvim";
    nv = "nvim";
  };
in
{
  imports = [
    ./map-leader.nix
    ./colorschemes/gruvbox-material.nix
    ./lsp.nix

    ./plugins/blink.nix
    ./plugins/conform.nix
    ./plugins/treesitter.nix

    ./plugins/nvim-tree.nix
    ./plugins/bufferline.nix
    ./plugins/zen-mode.nix
    ./plugins/autopairs.nix
    ./plugins/fzf-lua.nix
    ./plugins/render-markdown.nix
    ./plugins/claudecode.nix
    ./plugins/slash.nix
    ./plugins/vim-test.nix

    ./plugins/dap.nix
    ./plugins/dap-ui.nix

    ./plugins/gitsigns.nix
    ./plugins/fugitive.nix

    ./plugins/todo-comments.nix
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withRuby = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      targets-vim
      vim-repeat
      vim-surround
      vim-tmux-navigator
      nvim-web-devicons
    ];

    extraPackages = with pkgs; [
      xclip
    ];

    extraConfig = builtins.readFile ./init.vim;
  };

  programs.bash.shellAliases = aliases;
}
