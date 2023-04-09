{ pkgs, ... }:

let
  typewriter = {
    plugin = pkgs.vimUtils.buildVimPlugin {
      name = "typewriter-vim";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "joaolucasete";
        repo = "typewriter.vim";
        rev = "aa88d8698631f7be0f1aa8e153b3adc1b99be985";
        sha256 = "sha256-OQTuEgsRQ4LkHnZbEOpJjcU/4ur+GyPXu/wrUIsqMRY=";
      };
    };
  };
in
{
  programs.neovim.plugins = [ typewriter ];
}

