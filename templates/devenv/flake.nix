{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    devenv.url = "github:cachix/devenv";
  };

  outputs = { self, nixpkgs, utils, devenv, ... } @ inputs:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells =
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/languages/
                  languages = {
                    # put programming languages here
                  };

                  # https://devenv.sh/reference/options/#servicesopensearchsettingstransportport
                  services = {
                    # put services here
                  };

                  # https://devenv.sh/reference/options/
                  packages = [
                    # put your packages here
                  ];

                  enterShell = ''
                    
                  '';
                }
              ];
            };
          };
      });
}

