{ homeDirectory, ... }:

let
  bitwardenAgentSocket = "${homeDirectory}/.bitwarden-ssh-agent.sock";
in
{
  imports = [ ./ssh-common.nix ];

  # Bitwarden desktop on Linux exposes its SSH agent socket directly in
  # $HOME. Enable it under Settings > SSH agent. See:
  # https://bitwarden.com/help/ssh-agent/
  home.sessionVariables.SSH_AUTH_SOCK = bitwardenAgentSocket;

  programs.bash.initExtra = ''
    export SSH_AUTH_SOCK="${bitwardenAgentSocket}"
  '';

  programs.ssh.settings."github.com".IdentityAgent = bitwardenAgentSocket;
}
