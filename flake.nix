{
  description = "My Nix dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @inputs:
    let
      homeLib = import ./lib inputs;
      lib = nixpkgs.lib;

      configurations = {
        wsl = {
          system = "x86_64-linux";
          name = "wsl";
          username = "codando";
          homeDirectory = "/home/codando";
          stateVersion = "21.11";
        };

        fedora = {
          system = "x86_64-linux";
          name = "fedora";
          username = "codando";
          homeDirectory = "/home/codando";
          stateVersion = "25.05";
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
      homeConfigurations = builtins.mapAttrs
        (
          configurationName: config:
            homeLib.mkHome (config // { inherit configurationName; })
        )
        configurations;

      templates = import ./templates;

      formatter = forEachSystem (
        system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          dotnetSdk = pkgs.dotnetCorePackages.sdk_8_0;
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nil
              nixpkgs-fmt
            ];
          };

          dotnet = pkgs.mkShell {
            packages = [
              dotnetSdk
              pkgs.nodejs_22
            ];

            DOTNET_ROOT = "${dotnetSdk}/share/dotnet";
            DOTNET_CLI_TELEMETRY_OPTOUT = "1";
            DOTNET_NOLOGO = "1";
          };
        }
      );

      checks = builtins.foldl'
        (
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
        )
        { }
        (builtins.attrNames configurations);
    };
}
