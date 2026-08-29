{ config, lib, ... }:

let
  agentSocket = "${config.home.homeDirectory}/.ssh/proton-pass-agent.sock";
in
{
  imports = [ ./ssh.nix ];

  programs.ssh.settings."github.com".IdentityAgent = agentSocket;

  home.activation.protonPassAgentSocket = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ln -sfn "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/proton-pass-agent" "${agentSocket}"
  '';
}
