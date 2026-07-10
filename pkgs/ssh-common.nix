{
  programs.ssh = {
    enable = true;
    # Opt out of the deprecated implicit `Host *` defaults (they matched
    # OpenSSH's own built-in defaults anyway).
    enableDefaultConfig = false;
    settings."github.com".User = "git";
  };
}
