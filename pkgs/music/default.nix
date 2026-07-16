{ config, pkgs, ... }:

let
  mpdscrobble = pkgs.python3Packages.callPackage ./mpdscrobble.nix { };
  mpd-lyricsd = pkgs.callPackage ./mpd-lyricsd.nix { };
in
{
  # Adapted from https://github.com/LoneWolf4713/new-wave's mpd/ncmpcpp/
  # mpdscrobble/mpd-lyricsd setup. Two packages aren't in nixpkgs and are
  # built from source here (see mpdscrobble.nix, mpd-lyricsd.nix) - the
  # latter patched per the rice's own README instructions (fixed lyrics.txt
  # output instead of one file per song).
  #
  # Everything that used to be `exec`'d from the sway config (mpd itself,
  # mpdscrobble, mpd-lyricsd, mpd-notify) now runs as a proper systemd user
  # service instead, same reasoning as waybar/dunst/eww.
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

  # mpdscrobble: fill in ~/.config/mpdscrobble/mpdscrobble.conf yourself
  # (Last.fm and/or ListenBrainz credentials) - the shipped template has
  # empty fields, the original rice's committed one did too.
  xdg.configFile."mpdscrobble/mpdscrobble.conf" = {
    source = ./mpdscrobble.conf;
    force = false; # don't clobber credentials you fill in by hand
  };

  systemd.user.services.mpdscrobble = {
    Unit = {
      Description = "mpdscrobble";
      After = [ "mpd.service" ];
    };
    Service.ExecStart = "${mpdscrobble}/bin/mpdscrobble";
    Install.WantedBy = [ "default.target" ];
  };

  # mpd-lyricsd: fill in your own Genius API token in
  # ~/.config/mpd-lyricsd/config.toml (see the file's comment) - the
  # original rice repo committed what looks like the author's own live
  # token, which isn't reused here.
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
