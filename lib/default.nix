{ ... } @inputs:

let
  prelude = import ./prelude.nix;
in
{
  mkHome =
    { name
    , username
    , homeDirectory
    , system ? "x86_64-linux"
    , stateVersion
    , allowUnfree ? true
    , modules ? [ ]
    }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = allowUnfree;
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        {
          home = { inherit username homeDirectory stateVersion; };
        }
        (../home-configurations + "/${name}")
      ] ++ modules;

      extraSpecialArgs = {
        inherit inputs system username homeDirectory prelude;
      };
    };
}
