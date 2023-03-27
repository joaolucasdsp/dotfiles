{
  inputs.lean4.url = "github:leanprover/lean4";
  inputs.lean4.inputs.nixpkgs.follows = "nixpkgs-unstable";

  outputs = { self, nixpkgs, lean4 }:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ lean4.overlay ];
      };
      system = "x86_64-linux";
    in
    {
      devShell = pkgs.mkShell {
        name = "lean4-devshell";
        buildInputs = [
          pkgs.lean4
        ];
      };

      lean4 = pkgs.lean4;
    };
}
