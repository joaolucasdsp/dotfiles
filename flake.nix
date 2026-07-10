{
  description = "My nix dotfiles (WSL)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
        stateVersion = "21.11";
      };

      templates = import ./templates;

      formatter.${system} = pkgs.nixpkgs-fmt;

      checks.${system}.homeConfigurations-wsl =
        self.homeConfigurations.wsl.activationPackage;

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixpkgs-fmt
        ];
      };
    };
}
