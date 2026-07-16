{ pkgs, ... }:

{
  # Adapted from https://github.com/LoneWolf4713/new-wave, which vendors
  # adi1090x/rofi wholesale (all launcher/powermenu/applet styles, not just
  # the ones this rice actually binds) so cross-references between sibling
  # style files keep working. Two hardcoded /home/prtyksh paths were fixed
  # (config.rasi's default @theme, and the powermenu's lock action, which
  # pointed at a wallpaper image that isn't included here).
  #
  # Only launchers/type-7 (sway $mod+d) and powermenu/type-6 (XF86PowerOff)
  # are actually wired up; the rest is available if you want to bind more of
  # it later. The Arch-oriented applets (apps/battery/brightness/volume/
  # screenshot/quicklinks — pacman, acpi, light) aren't bound to anything
  # and won't work as-is on Fedora if invoked directly.
  home.packages = with pkgs; [
    rofi
    wmctrl
    libnotify
  ];

  xdg.configFile.rofi = {
    source = ./rofi;
    recursive = true;
  };
}
