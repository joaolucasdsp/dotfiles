{ config, pkgs, ... }:

let
  mpdscrobble = pkgs.python3Packages.callPackage ./mpdscrobble.nix { };
  mpd-lyricsd = pkgs.callPackage ./mpd-lyricsd.nix { };
in
{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      zeroconf_enabled "yes"
      zeroconf_name "Music Player @ %h"

      audio_output {
        type "pulse"
        name "My Pulse Output"
      }

      audio_output {
        type "fifo"
        name "my_fifo"
        path "/tmp/mpd.fifo"
        format "44100:16:2"
      }
    '';
  };

  home.packages = with pkgs; [
    mpc
    ncmpcpp
    ffmpeg
    playerctl
  ];

  xdg.configFile."ncmpcpp/config".source = ./ncmpcpp.conf;

  xdg.configFile."mpdscrobble/mpdscrobble.conf" = {
    source = ./mpdscrobble.conf;
    force = false;
  };

  systemd.user.services.mpdscrobble = {
    Unit = {
      Description = "mpdscrobble";
      After = [ "mpd.service" ];
    };
    Service.ExecStart = "${mpdscrobble}/bin/mpdscrobble";
    Install.WantedBy = [ "default.target" ];
  };

  xdg.configFile."mpd-lyricsd/config.toml" = {
    source = ./mpd-lyricsd-config.toml;
    force = false;
  };

  systemd.user.services.mpd-lyricsd = {
    Unit = {
      Description = "mpd-lyricsd";
      After = [ "mpd.service" ];
    };
    Service.ExecStart = "${mpd-lyricsd}/bin/mpd-lyricsd";
    Install.WantedBy = [ "default.target" ];
  };

  home.file."mpd-notify-script" = {
    target = ".config/mpd/mpd-notify";
    source = ./mpd-notify;
    executable = true;
  };

  systemd.user.services.mpd-notify = {
    Unit = {
      Description = "mpd-notify (song-change notifications)";
      After = [ "mpd.service" ];
    };
    Service.ExecStart = "%h/.config/mpd/mpd-notify";
    Install.WantedBy = [ "default.target" ];
  };
}
