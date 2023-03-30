{
  description = "Lean4 flake nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    lean4.url = "github:leanprover/lean4";
  };
  outputs = { self, nixpkgs, lean4 }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in {
      devShells."x86_64-linux".default = pkgs.mkShell {
        name = "lean4-devshell";
        buildInputs = [ lean4.defaultPackage."x86_64-linux"];
      };
    };
}
