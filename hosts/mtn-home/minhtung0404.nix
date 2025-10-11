{
  pkgs,
  config,
  inputs,
  ...
}:
let
  user = "minhtung0404";
  home = "/home/minhtung0404";
in
{
  mtn = {
    hm.enable = true;
    username = user;
    programs = {
      my-zenbrowser.enable = true;
      my-niri.enable = true;
      my-waybar = {
        enable = true;
        fontSize = 15.0;
        enableMpd = true;
      };
    };

    linux.graphical = {
      type = "wayland";
      wallpaper = ../../images/kuriyama_mirai.png;
      defaults = {
        webBrowser = {
          package = config.programs.zen-browser.finalPackage;
          desktopFile = "zen.desktop";
        };
      };
    };
  };
  # programs.alacritty.enable = true; # Super+T in the default setting (terminal)
  # programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
  # programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
  # programs.waybar.enable = true; # launch on startup in the default setting (bar)
  # services.mako.enable = true; # notification daemon
  # services.swayidle.enable = true; # idle management daemon
  # services.polkit-gnome.enable = true; # polkit
  # home.packages = with pkgs; [
  #   swaybg # wallpaper
  # ];

  home.username = user;
  home.homeDirectory = home;
}
