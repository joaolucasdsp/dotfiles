{
  programs.ssh = {
    enable = true;
    # Opt out of the deprecated implicit `Host *` defaults (they matched
    # OpenSSH's own built-in defaults anyway).
    enableDefaultConfig = false;
    settings."github.com".User = "git";
  };

  # Proton Pass serves the SSH keys: the private key stays in the vault and
  # never touches disk. The module runs `pass-cli ssh-agent start` under
  # launchd (macOS) or a systemd user service (Linux) and exports
  # SSH_AUTH_SOCK, so all three platforms share this one block.
  #
  # Needs a one-time `pass-cli login` per machine. The agent reads the session
  # from the system keychain and fails silently if it isn't logged in.
  # https://protonpass.github.io/pass-cli/commands/ssh-agent/
  services.proton-pass-agent = {
    enable = true;
    # Only the "Security" vault holds SSH key items; scoping keeps the agent
    # from re-scanning ~200 login items in the other vaults on every refresh.
    extraArgs = [ "--vault-name" "Security" ];
  };
}
