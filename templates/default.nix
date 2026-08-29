{
  basic = {
    description = "A very basic flake";
    path = ./basic;
  };

  lean4 = {
    description = "A lean4 project template";
    path = ./lean4;
  };

  python = {
    description = "A python project template using devenv";
    path = ./python;
  };

  devenv = {
    description = "A simple devenv flake";
    path = ./devenv;
  };

  c = {
    description = "A simple C flake";
    path = ./c;
  };

  rust = {
    description = "A simple Rust flake";
    path = ./rust;
  };

  ocaml = {
    description = "A simple OCaml project using Dune";
    path = ./ocaml;
  };
}
