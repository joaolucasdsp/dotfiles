{ pkgs, ... }:

{
  programs.eww = {
    enable = true;
    yuckConfig = builtins.readFile ./eww.yuck;
    scssConfig = builtins.readFile ./eww.scss;
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    playerctl
    ffmpeg
    feh
    jq
  ];

  home.file = {
    "eww-music-script" = {
      target = ".config/eww/music";
      source = ./music;
      executable = true;
    };
    "eww-getsongduration-script" = {
      target = ".config/eww/getSongDuration";
      source = ./getSongDuration;
      executable = true;
    };
    "eww-fallback-cover" = {
      target = ".config/eww/fallback.png";
      source = ./fallback.png;
    };
  };

  systemd.user.services.eww-open = {
    Unit = {
      Description = "Open the new-wave eww music widget";
      After = [ "eww.service" ];
      Requires = [ "eww.service" ];
      PartOf = [ "eww.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.eww}/bin/eww open example";
    };
    Install.WantedBy = [ "eww.service" ];
  };
}
