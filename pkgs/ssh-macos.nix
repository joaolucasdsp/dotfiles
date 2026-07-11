{ homeDirectory, ... }:

let
  bitwardenAgentSocket = "${homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
in
{
  imports = [ ./ssh-common.nix ];

  # Bitwarden installed from the Mac App Store exposes its SSH agent socket
  # inside the application's sandbox container. See:
  # https://bitwarden.com/help/ssh-agent/
  home.sessionVariables.SSH_AUTH_SOCK = bitwardenAgentSocket;

  programs.bash.initExtra = ''
    export SSH_AUTH_SOCK="${bitwardenAgentSocket}"
  '';

  # OrbStack manages its hosts in a separate generated file.
  programs.ssh.includes = [ "~/.orbstack/ssh/config" ];

  programs.ssh.settings."github.com".IdentityAgent = bitwardenAgentSocket;
}
