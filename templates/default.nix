{
  # nix flake init -t github:joaolucasete/dotfiles#templates.basic
  basic = {
    description = "A very basic flake";
    path = ./basic;
  };

  # nix flake init -t github:joaolucasete/dotfiles#templates.lean4
  lean4 = {
    description = "Lean4 Project Template";
    path = ./lean4;
  };
}
