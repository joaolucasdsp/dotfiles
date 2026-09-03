{
  basic = {
    description = "A very basic flake";
    path = ./basic;
  };

  devenv = {
    description = "A simple devenv flake";
    path = ./devenv;
  };

  c = {
    description = "A C project template using CMake";
    path = ./c;
  };

  go = {
    description = "A Go project template";
    path = ./go;
  };

  haskell = {
    description = "A Haskell project template";
    path = ./haskell;
  };

  lean4 = {
    description = "A Lean 4 project template";
    path = ./lean4;
  };

  node = {
    description = "A Node.js project template";
    path = ./node;
  };

  ocaml = {
    description = "An OCaml project template using Dune";
    path = ./ocaml;
  };

  python = {
    description = "A Python project template using devenv";
    path = ./python;
  };

  rust = {
    description = "A Rust project template";
    path = ./rust;
  };

  zig = {
    description = "A Zig project template";
    path = ./zig;
  };
}
