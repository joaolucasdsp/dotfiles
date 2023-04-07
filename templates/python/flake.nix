{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, devenv, utils, ... } @ inputs:

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
                  languages.python = {
                    enable = true;
                    venv = {
                      enable = true;
                    };
                  };
                  # https://devenv.sh/reference/options/
                  packages = with pkgs; [
                    rnix-lsp
                  ];

                  enterShell = ''
                  '';
                }
              ];
            };
          };
      });
}
