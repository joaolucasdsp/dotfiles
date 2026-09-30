{ config, lib, pkgs, ... }:

let
  agentSocket = "${config.home.homeDirectory}/.ssh/proton-pass-agent.sock";

  # Where proton-pass-agent actually listens; ~/.ssh gets a stable symlink to it.
  runtimeSocket =
    if pkgs.stdenv.hostPlatform.isDarwin
    then ''"$(/usr/bin/getconf DARWIN_USER_TEMP_DIR)/proton-pass-agent"''
    else ''"''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/proton-pass-agent"'';
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com".User = "git";
    settings."*".IdentityAgent = agentSocket;
  };

  services.proton-pass-agent = {
    enable = true;
    extraArgs = [ "--vault-name" "Security" ];
  };

  home.activation.protonPassAgentSocket = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${config.home.homeDirectory}/.ssh"
    run ln -sfn ${runtimeSocket} "${agentSocket}"
  '';
}
