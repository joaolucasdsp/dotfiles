{ homeDirectory, ... }:

let
  bitwardenAgentSocket = "${homeDirectory}/.bitwarden-ssh-agent.sock";
in
{
  imports = [ ./ssh-common.nix ];

  # Bitwarden SSH Agent on macOS exposes a Unix socket in the user's home
  # directory for the .dmg/Homebrew app. See:
  # https://bitwarden.com/help/ssh-agent/
  home.sessionVariables.SSH_AUTH_SOCK = bitwardenAgentSocket;

  programs.bash.initExtra = ''
    export SSH_AUTH_SOCK="${bitwardenAgentSocket}"
  '';

  programs.ssh.settings."github.com".IdentityAgent = bitwardenAgentSocket;
}
