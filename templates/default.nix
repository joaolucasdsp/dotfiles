{
  # nix flake init -t github:joaolucasete/dotfiles#templates.basic
  basic = {
    description = "A very basic flake";
    path = ./basic;
  };

  # nix flake init -t github:joaolucasete/dotfiles#templates.lean4
  lean4 = {
    description = "A lean4 project template";
    path = ./lean4;
  };

  # nix flake init -t github:joaolucasete/dotfiles#templates.python
  python = {
    description = "A python project template using devenv";
    path = ./python;
  };

  # nix flake init -t github:joaolucasete/dotfiles#templates.devenv
  devenv = {
    description = "A simple devenv flake";
    path = ./devenv;
  };

  # nix flake init -t github:joaolucasete/dotfiles#templates.c
  c = {
    description = "A simple C flake";
    path = ./c;
  };
}
