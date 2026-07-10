{
  description = "My nix dotfiles (WSL)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @inputs:
    let
      lib = import ./lib inputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations.wsl = lib.mkHome {
        inherit system;
        name = "wsl";
        username = "codando";
        homeDirectory = "/home/codando";
      };

      templates = import ./templates;

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ pkgs.nixpkgs-fmt ];
      };
    };
}
