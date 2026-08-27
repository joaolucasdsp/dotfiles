{
  # The Proton Pass agent (see ./ssh-common.nix) runs natively inside WSL as a
  # systemd user service, so no Windows bridge is needed any more: the old
  # socat + npiperelay.exe relay to //./pipe/openssh-ssh-agent is gone.
  #
  # Requires systemd in WSL (`systemd=true` under [boot] in /etc/wsl.conf).
  imports = [ ./ssh-common.nix ];
}
