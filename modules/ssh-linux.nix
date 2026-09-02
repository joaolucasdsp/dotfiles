{ config, lib, pkgs, ... }:

let
  agentSocket = "${config.home.homeDirectory}/.ssh/proton-pass-agent.sock";
  passCli = lib.getExe' config.services.proton-pass-agent.package "pass-cli";
  patFile = config.sops.secrets.proton-pass-pat.path;

  loginScript = pkgs.writeShellScript "proton-pass-login" ''
    set -euo pipefail

    pass_cli=${passCli}
    pat_file=${patFile}

    if "$pass_cli" info >/dev/null 2>&1; then
      exit 0
    fi

    if [ ! -r "$pat_file" ]; then
      echo "proton pass: no personal access token at $pat_file" >&2
      exit 1
    fi

    "$pass_cli" login --pat "$(cat "$pat_file")"
  '';
in
{
  imports = [ ./ssh.nix ./sops.nix ];

  programs.ssh.settings."github.com".IdentityAgent = agentSocket;

  sops.secrets.proton-pass-pat = { };

  systemd.user.services.proton-pass-login = {
    Unit = {
      Description = "Restore the Proton Pass CLI session from a personal access token";
      Wants = [ "sops-nix.service" ];
      After = [ "sops-nix.service" ];
      StartLimitIntervalSec = 0;
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      KeyringMode = "shared";
      ExecStart = loginScript;
      Restart = "on-failure";
      RestartSec = 30;
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.proton-pass-agent = {
    Unit = {
      Wants = [ "proton-pass-login.service" ];
      After = [ "proton-pass-login.service" ];
      StartLimitIntervalSec = 0;
    };
    Service.RestartSec = 30;
  };

  home.activation.protonPassAgentSocket = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ln -sfn "''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/proton-pass-agent" "${agentSocket}"
  '';
}
