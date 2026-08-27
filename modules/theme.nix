{ config, pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.nightfox-gtk-theme;
      name = "Nightfox-Dark";
    };
    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Blue-Dark";
    };
    font = {
      package = pkgs.inter;
      name = "Inter";
      size = 10;
    };
    gtk4.theme = config.gtk.theme;
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    material-design-icons
  ];
}
