{ ... }:

{
  programs.waybar = {
    enable = true;
    settings = [ (builtins.fromJSON (builtins.readFile ./config.json)) ];
    style = ./style.css;

    systemd.enable = true;
  };
}
