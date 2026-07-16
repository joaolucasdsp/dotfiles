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

    # Commit signing with SSH (key served by the Bitwarden agent).
    signing = {
      format = "ssh";
      key = "~/${signingKeyFile}";
      signByDefault = true;
    };

    settings = {
      user.name = "codando";
      user.email = "joaolwork@gmail.com";
      core.editor = "vim";
      # gitFull bakes in an absolute path to nixpkgs' own OpenSSH. On non-NixOS
      # hosts (e.g. Fedora) that upstream ssh reads the system's
      # /etc/crypto-policies openssh.config but doesn't understand its Red Hat
      # GSSAPIKexAlgorithms / mlkem KEX entries, so it aborts and pushes fail.
      # Use the system ssh from PATH instead, which supports that config.
      core.sshCommand = "ssh";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
      init.defaultBranch = "main";
      # Verify signatures locally against ~/.ssh/allowed_signers
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };

    # Global ignores
    ignores = [
      "*~"
      "*.swp"
      # ".envrc"
      ".direnv"
    ];
  };

  home.file = {
    "${signingKeyFile}".text = ''
      ${signingKey}
    '';

    ".ssh/allowed_signers".text = ''
      joaolwork@gmail.com ${signingKey}
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
