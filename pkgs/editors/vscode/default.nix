{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium;
    package = pkgs.vscode.fhs;
    # userSettings = import ./settings.nix;
    # keybindings = import ./keybindings.nix;
    # extensions = with pkgs.vscode-extensions; [
    #   # ionide.ionide-fsharp
    #   # ms-vsliveshare.vsliveshare
    #   # github.github-vscode-theme
    #   # pkief.material-icon-theme
    #   # usernamehw.errorlens
    #   # vscodevim.vim
    #   ms-dotnettools.csharp
    # ] ++ extensions;
  };
}
