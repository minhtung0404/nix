{
  flake.modules.nixos.inputMethods = { pkgs, ... }: {
    # Input methods (only fcitx5 works reliably on Wayland)
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        qt6Packages.fcitx5-unikey
        fcitx5-gtk
      ];
    };
  };
}
