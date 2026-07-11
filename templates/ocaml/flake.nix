{
  description = "An OCaml project template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ocaml-run = pkgs.writeShellScriptBin "ocaml-run" ''
          exec dune exec ./bin/main.exe -- "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = (with pkgs.ocamlPackages; [
            ocaml
            dune_3
            findlib
            ocaml-lsp
            ocamlformat
            utop
          ]) ++ [
            pkgs.nil
            ocaml-run
          ];
        };
      });
}
