{
  den.aspects.nixosGtk.homeManager = { pkgs, config, ... }: {
    # Theming
    ## GTK
    gtk.enable = true;
    gtk.font.name = "IBM Plex Sans JP";
    gtk.font.size = 10;
    gtk.iconTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze";
    };
    # gtk.theme = {
    #   package = pkgs.kdePackages.breeze-gtk;
    #   name = "Breeze";
    # };
    gtk.gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      force = true;
      extraConfig = ''
        gtk-enable-animations=1
        gtk-im-module="fcitx"
        gtk-theme-name="Numix"
        gtk-primary-button-warps-slider=1
        gtk-toolbar-style=3
        gtk-menu-images=1
        gtk-button-images=1
        gtk-sound-theme-name="ocean"
        gtk-icon-theme-name="breeze"
      '';
    };
    # noctalia's gtk3 template recolors GTK 3 through libadwaita color names, which
    # only the adw-gtk3 theme reads; noctalia selects adw-gtk3 / adw-gtk3-dark itself
    # (gsettings), so gtk.theme stays unset
    home.packages = [ pkgs.adw-gtk3 ];
    gtk.gtk3.extraConfig.gtk-im-module = "fcitx";
    gtk.gtk4.extraConfig.gtk-im-module = "fcitx";
  };
}
