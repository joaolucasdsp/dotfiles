{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."github.com".User = "git";
  };

  services.proton-pass-agent = {
    enable = true;
    extraArgs = [ "--vault-name" "Security" ];
  };
}
