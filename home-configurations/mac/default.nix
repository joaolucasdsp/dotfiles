{ pkgs, lib, username, homeDirectory, ... }:

let
  shellConfig = {
    # initExtra = "
    #   . ~/.nix-profile/etc/profile.d/nix.sh
    # ";
    shellAliases = {
      rb = "nix build .#homeConfigurations.mac.activationPackage && result/activate";
    };
  };
in
{
  imports = [
    ../../utils/scripts

    # CLI
    ../../pkgs/base16-shell.nix # Different shell themes
    ../../pkgs/zoxide.nix # Jump directories
    ../../pkgs/bash.nix # Shell
    ../../pkgs/editors/nvim
    ../../pkgs/readline # GNU readline input
    # ../../pkgs/git.nix
    ../../pkgs/tmux # Terminal multiplexer
    ../../pkgs/fzf.nix # Fuzzy finder
    # ../../pkgs/eza.nix # ls alternative
    # ../../pkgs/trash-cli.nix # Safer rm
    ../../pkgs/htop.nix # Process viewer
    #../../pkgs/keychain.nix # Ssh key caching
    ../../pkgs/gpg.nix
    ../../pkgs/jq.nix # Work with json
    # ../../pkgs/bat.nix # File previewer
    # ../../pkgs/newsboat.nix # News reader
    # ../../pkgs/tiny.nix # TUI IRC client
    ../../pkgs/direnv.nix

    #../../services/gpg-agent.nix
  ];

  home.packages = with pkgs; [
    # CLI
    # bandwhich # Network inspector
    tealdeer # TLDR of man pages
    ripgrep # File content finder
    fd # File finder
    # ncdu # Curses interface for `du`
    file # Shows info about files
    neofetch # Shows system information
    pfetch # Smaller neofetch

    # Microsoft Stack Development
    # .NET Development
    dotnet-sdk_8
    omnisharp-roslyn
    # csharp-ls # Not available on aarch64-darwin
    
    # Node.js/TypeScript/Angular Development
    nodejs_20
    nodePackages.yarn
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages."@angular/cli"
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.vscode-langservers-extracted
    
    # Additional development tools
    # nodePackages.csharpier # C# formatter (commented out - not available in nixpkgs)
    
    # OCaml development (keeping existing)
    ocaml
    opam
    dune_3
    ocamlPackages.ocaml-lsp
    ocamlPackages.merlin
    ocamlPackages.ocp-indent

    # take notes
    # nb

    # ffmpeg
    # espeak-classic
    # mpv
  ];

  programs.bash = shellConfig;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "${username}";
  home.homeDirectory = homeDirectory;
}
