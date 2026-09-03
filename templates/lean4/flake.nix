{
  description = "A Lean 4 project template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lean4.url = "github:leanprover/lean4";
  };

  outputs = { nixpkgs, lean4, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "lean4-devshell";
            packages = [
              lean4.packages.${system}.default
            ];
          };
        }
      );
    };
}
