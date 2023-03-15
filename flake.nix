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

    nixgl.url = "github:guibou/nixGL";

    # Misc
    suckless.url = "github:arcticlimer/suckless";
    nix-colors.url = "github:misterio77/nix-colors";
    flake-utils.url = "github:numtide/flake-utils";
  };

	 outputs = { self, flake-utils, nixpkgs, nix-colors, nixpkgs-master, nixgl, ... } @inputs:
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
      
      homeConfigurations =
        let
          system = "x86_64-linux";
          username = "codando";
        in
        {
			# nix build ".#homeConfigurations.debian.activationPackage" --impure
          debian = lib.mkHome {
            inherit system username;
            name = "debian";
            overlays = [
              nixgl.overlay
              inputs.suckless.overlays
            ];
            colorscheme = inputs.nix-colors.colorSchemes.nord;
          };
          wsl = lib.mkHome {
            inherit system username;
            name = "wsl";
          };
        };
      templates = import ./templates;
    } // devShells;

}
