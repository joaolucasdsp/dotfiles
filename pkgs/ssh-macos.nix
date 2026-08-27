{
  imports = [ ./ssh-common.nix ];

  # OrbStack manages its hosts in a separate generated file.
  programs.ssh.includes = [ "~/.orbstack/ssh/config" ];
}
