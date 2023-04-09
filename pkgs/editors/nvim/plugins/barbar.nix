{ pkgs, prelude, ... }:

let
  barbar = {
    plugin = pkgs.vimUtils.buildVimPlugin {
      name = "barbar-nvim";
      version = "2023-03-09";
      src = pkgs.fetchFromGitHub {
        owner = "romgrk";
        repo = "barbar.nvim";
        rev = "f37cbed0320bea7cdc756fde4e54fd2e36991cbc";
        sha256 = "sha256-1x6+UKsZ8E+i5D69s1f5cuui6reg3ulnzAf5oPWJjWI=";
      };
    };
    config = ''
    '';
  };
in
{
  programs.neovim.plugins = [ barbar ];
}
