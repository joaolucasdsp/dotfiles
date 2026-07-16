{ config, pkgs, ... }:

{
  # Adapted from https://github.com/LoneWolf4713/new-wave's GTK theme
  # section (gsettings calls in the sway config). Uses home-manager's gtk/
  # pointerCursor modules instead of exec_always + gsettings, so it's
  # applied declaratively rather than shelled out on every sway start.
  #
  # Substitutions from the original:
  # - Nightfox-Dusk-B -> Nightfox-Dark: nixpkgs' nightfox-gtk-theme only
  #   ships the Dark/Light variants, not the author's specific Dusk-B one.
  # - Dropped the 'SF Pro Display' system font: it's an Apple-licensed font
  #   with no legitimate nixpkgs package (the rice pulled it from an
  #   unofficial GitHub redistribution). Using Inter instead, a common
  #   open-source substitute with similar metrics.
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
    # Not sway.enable: that option writes to wayland.windowManager.sway.config,
    # which pkgs/sway sets to null (we use a raw extraConfig file instead).
    # XCURSOR_THEME/XCURSOR_SIZE session variables (set below by this same
    # module) are sufficient for the cursor theme to apply.
  };

  # Nerd Font for waybar/kitty glyphs, Material Design Icons for waybar's
  # icon fonts (referenced in pkgs/waybar/style.css).
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    material-design-icons
  ];
}
