{ pkgs, ... }:

{
  # `socat` is used to bridge the Windows named pipe into a Unix socket.
  # `npiperelay.exe` is a Windows binary and must live on the Windows PATH
  # (it cannot be installed through Nix inside WSL).
  home.packages = [ pkgs.socat ];

  # Declarative ~/.ssh/config. On the first activation Home Manager backs up
  # any existing file to ~/.ssh/config.hm-backup.
  programs.ssh = {
    enable = true;
    # Opt out of the deprecated implicit `Host *` defaults (they matched
    # OpenSSH's own built-in defaults anyway).
    enableDefaultConfig = false;
    settings."github.com".User = "git";
  };

  # --- Bitwarden SSH agent bridge (Windows -> WSL) ---
  # Prereqs on Windows:
  #   1. Bitwarden desktop: Settings > enable "SSH agent".
  #   2. Disable the "OpenSSH Authentication Agent" Windows service
  #      (Bitwarden serves the //./pipe/openssh-ssh-agent pipe itself).
  #   3. Put npiperelay.exe somewhere on the Windows PATH.
  # The private key stays in the Bitwarden vault and never touches disk.
  programs.bash.initExtra = ''
    if command -v npiperelay.exe >/dev/null 2>&1; then
      export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
      if ! ss -a 2>/dev/null | grep -q "$SSH_AUTH_SOCK"; then
        rm -f "$SSH_AUTH_SOCK"
        (setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork \
          EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
      fi
    fi
  '';
}
