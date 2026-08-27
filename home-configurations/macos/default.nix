{ pkgs, ... }:

{
  imports = [
    ../common
    ../../modules/base16-shell.nix
    ../../modules/ssh-macos.nix
  ];

  home.packages = with pkgs; [
    coreutils
  ];
}
