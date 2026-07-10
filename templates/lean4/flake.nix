{
  description = "Lean4 flake nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    lean4.url = "github:leanprover/lean4";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, lean4, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "lean4-devshell";
          packages = [
            lean4.packages.${system}.default
          ];
        };
      });
}
