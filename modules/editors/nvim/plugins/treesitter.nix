{ pkgs, ... }:

let
  treesitter = {
    plugin = pkgs.vimPlugins.nvim-treesitter.withPlugins (
      p: with p; [
        angular
        bash
        c_sharp
        css
        diff
        dockerfile
        go
        html
        javascript
        json
        lua
        markdown
        markdown_inline
        nix
        ocaml
        python
        query
        rust
        scss
        sql
        toml
        tsx
        typescript
        vim
        vimdoc
        yaml
      ]
    );
    type = "lua";
    config = ''
      local treesitter_indent = { htmlangular = true, nix = true, toml = true }

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", {}),
        callback = function(args)
          if not pcall(vim.treesitter.start, args.buf) then
            return
          end
          if treesitter_indent[args.match] then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    '';
  };

  autotag = {
    plugin = pkgs.vimPlugins.nvim-ts-autotag;
    type = "lua";
    config = ''
      require("nvim-ts-autotag").setup()
    '';
  };
in
{
  programs.neovim.plugins = [
    treesitter
    autotag
  ];
}
