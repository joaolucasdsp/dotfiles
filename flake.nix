{
  description = "My Nix dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @inputs:
    let
      homeLib = import ./lib inputs;
      lib = nixpkgs.lib;

      # Add future Home Manager environments here. The outputs below are
      # generated automatically for every declared configuration and system.
      configurations = {
        wsl = {
          system = "x86_64-linux";
          name = "wsl";
          username = "codando";
          homeDirectory = "/home/codando";
          stateVersion = "21.11";
        };

        macos = {
          system = "aarch64-darwin";
          name = "macos";
          username = "joaop";
          homeDirectory = "/Users/joaop";
          stateVersion = "21.11";
        };
      };

      systems = lib.unique (map (config: config.system) (
        builtins.attrValues configurations
      ));

      forEachSystem = lib.genAttrs systems;
    in
    {
      homeConfigurations = builtins.mapAttrs (
        configurationName: config:
        homeLib.mkHome (config // { inherit configurationName; })
      ) configurations;

      templates = import ./templates;

      formatter = forEachSystem (
        system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nil
              nixpkgs-fmt
            ];
          };
        }
      );

      checks = builtins.foldl' (
        checks: configurationName:
        let
          system = configurations.${configurationName}.system;
        in
        checks // {
          ${system} = (checks.${system} or { }) // {
            "home-${configurationName}" =
              self.homeConfigurations.${configurationName}.activationPackage;
          };
        }
      ) { } (builtins.attrNames configurations);
    };
}
