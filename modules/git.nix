{ pkgs, prelude, ... }:

let

  signingKeyFile = ".ssh/SSH-pessoal-ed25519-2026.pub";
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHSr/EXnMuAWXZ3GxWgIVQsV/VvTC34CbgiGSd4r7J2h SSH-pessoal-ed25519-2026";

  aliases = {
    gw = "git worktree";
    gs = "git status";
    gc = "git commit";
    gl = "git log";
    gcl = "git clone";
    gco = "git checkout";
    glg = "git log --graph --oneline";
    gd = "git diff";
    gds = "git diff --staged";
    ga = "git add";
    gr = "git remote";
    grv = "git remote -v";
    gra = "git remote add";
    gp = "git push";
    gpl = "git pull";
    gb = "git branch";
    grs = "git restore";
    gsh = "git show";
  };
in
{
  programs.bash.shellAliases = aliases;

  programs.git = {
    enable = true;

    package = pkgs.gitFull;

    signing = {
      format = "ssh";
      key = "~/${signingKeyFile}";
      signByDefault = true;
    };

    settings = {
      # git@codando.io é o endereço só de commits da Codando, que também assina
      # o trabalho PJ para a criotive. Pode ser trocado se for coletado por spam
      # sem mexer no endereço de contato.
      user.name = "johnp";
      user.email = "git@codando.io";
      core.editor = "vim";
      core.sshCommand = "ssh";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };

    # Espelha projects-workspace/.gitignore_global. Aquele arquivo continua a
    # valer para as máquinas macOS e Windows, que o ativam pelo bootstrap.sh;
    # aqui o config global é somente leitura, então a lista vem declarada.
    ignores = [
      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"

      # Windows
      "Thumbs.db"
      "ehthumbs.db"
      "Desktop.ini"
      "$RECYCLE.BIN/"

      # Linux
      "*~"
      ".directory"
      ".Trash-*"

      # Editores / IDEs
      ".vscode/"
      ".idea/"
      "*.swp"
      "*.swo"
      "*.sublime-workspace"

      # Ambientes locais / segredos
      ".env"
      ".env.local"
      ".direnv"
    ];
  };

  home.file = {
    "${signingKeyFile}".text = ''
      ${signingKey}
    '';

    ".ssh/allowed_signers".text = ''
      joaolwork@gmail.com,joaop.dev@codando.tech,git@codando.io ${signingKey}
    '';
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "line-numbers decorations";
      syntax-theme = "gruvbox-dark";
      plus-style = ''syntax "#003800"'';
      minus-style = ''syntax "#3f0001"'';
      side-by-side = true;
      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
        hunk-header-decoration-style = "cyan box ul";
      };
      delta = {
        navigate = true;
      };
    };
  };
}
