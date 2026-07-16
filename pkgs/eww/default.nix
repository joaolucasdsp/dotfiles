{ pkgs, ... }:

{
  # Adapted from https://github.com/LoneWolf4713/new-wave's configs/eww.
  # Note the original rice never actually enabled eww (its exec line was
  # commented out in the sway config) - enabling it here since you asked
  # for it specifically.
  #
  # Two scripts eww.yuck depends on weren't in the rice repo at all:
  # - getSongDuration: written from scratch (pkgs/eww/getSongDuration).
  # - the "music" script's fallback cover art
  #   (~/.config/eww/dashboard/assets/fallback.png): pointed at a 1x1
  #   placeholder instead (pkgs/eww/fallback.png).
  # The lyrics poll reads ~/Music/.lyrics/lyrics.txt, written by
  # mpd-lyricsd — see pkgs/music (task 4).
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

  # Opens the widget window once the eww daemon (started by
  # programs.eww.systemd) is up.
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
