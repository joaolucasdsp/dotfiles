{
	description = "My nix dotfiles";

	  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Misc
    suckless.url = "github:arcticlimer/suckless";
    nix-colors.url = "github:misterio77/nix-colors";
    flake-utils.url = "github:numtide/flake-utils";
  };

	 outputs = { self, flake-utils, nixpkgs, nix-colors, nixpkgs-master, ... } @inputs:
    let
      lib = import ./lib inputs;
      devShells = flake-utils.lib.eachDefaultSystem (
        system: {
          devShell =
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            pkgs.mkShell {
              buildInputs = with pkgs; [
                # Nix development dependencies
                rnix-lsp
                nixpkgs-fmt
              ];
            };
        }
      );
    in
    {
      nixosConfigurations = {
        nixos = let 
          system = "x86_64-linux";
          pkgs-master = lib.mkNixpkgs {
            inherit system;
            nixpkgs = nixpkgs-master;
          };
          discord-overlay = final: prev: {
            discord = pkgs-master.discord;
          };
        in lib.mkHost {
          inherit system;
          host = "nixos";
          username = "joaop";
          overlays = [
            inputs.suckless.overlays
            discord-overlay
          ];
          homeModules = [
            nix-colors.homeManagerModule
          ];
          colorscheme = inputs.nix-colors.colorSchemes.nord;
        };
      };
      
      homeConfigurations =
        let
          system = "x86_64-linux";
          username = "joaop";
          homeDirectory = "/home/${username}";
        in
        {
			# nix build ".#homeConfigurations.debian.activationPackage" --impure
          debian = lib.mkHome {
            inherit system username homeDirectory;
            name = "debian";
            overlays = [
              inputs.suckless.overlays
            ];
            colorscheme = inputs.nix-colors.colorSchemes.nord;
          };
          arch = lib.mkHome {
            inherit system username homeDirectory;
            name = "arch";
            colorscheme = inputs.nix-colors.colorSchemes.nord;
          };
          wsl = lib.mkHome {
            inherit system username homeDirectory;
            name = "wsl";
          };
          mac = lib.mkHome {
            system = "aarch64-darwin";
            homeDirectory = "/Users/${username}";
            inherit username;
            name = "mac";
          };
        };
      templates = import ./templates;
    } // devShells;

}
