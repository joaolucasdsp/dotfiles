{ config, lib, ... }:

let
  agentSocket = "${config.home.homeDirectory}/.ssh/proton-pass-agent.sock";
in
{
  imports = [ ./ssh.nix ];

  programs.ssh.includes = [ "~/.orbstack/ssh/config" ];
  programs.ssh.settings."github.com".IdentityAgent = agentSocket;

  home.activation.protonPassAgentSocket = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ln -sfn "$(/usr/bin/getconf DARWIN_USER_TEMP_DIR)/proton-pass-agent" "${agentSocket}"
  '';
}
