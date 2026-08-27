{
  imports = [ ./ssh-common.nix ];

  programs.ssh.includes = [ "~/.orbstack/ssh/config" ];
}
