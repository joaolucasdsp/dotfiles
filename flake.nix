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
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${linuxSystem};
    in
    {
      homeConfigurations.wsl = lib.mkHome {
        system = linuxSystem;
        name = "wsl";
        username = "codando";
        homeDirectory = "/home/codando";
        stateVersion = "21.11";
      };

      homeConfigurations.macos = lib.mkHome {
        system = darwinSystem;
        name = "macos";
        username = "codando";
        homeDirectory = "/Users/codando";
        stateVersion = "21.11";
      };

      templates = import ./templates;

      formatter.${linuxSystem} = pkgs.nixpkgs-fmt;

      checks.${linuxSystem}.homeConfigurations-wsl =
        self.homeConfigurations.wsl.activationPackage;

      devShells.${linuxSystem}.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixpkgs-fmt
        ];
      };
    };
}
