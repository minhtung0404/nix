{
  flake.modules.nixos.screencast =
    {
      config,
      inputs,
      lib,
      pkgs,
      ...
    }:
    {
      # swaync disable notifications on screencast
      xdg.portal.wlr.settings.screencast = {
        exec_before = ''which swaync-client && swaync-client --inhibitor-add "xdg-desktop-portal-wlr" || true'';
        exec_after = ''which swaync-client && swaync-client --inhibitor-remove "xdg-desktop-portal-wlr" || true'';
      };

      # Niri stuff
      # https://github.com/sodiboo/niri-flake/blob/main/docs.md
      # programs.niri.enable = true;
      # # programs.niri.package = pkgs.niri-stable;
      # # Override gnome-keyring disabling
      # services.gnome.gnome-keyring.enable = lib.mkForce false;
      # # niri
      # nixpkgs.overlays = [ inputs.niri.overlays.niri ];
      # programs.niri.package = pkgs.niri-stable.override {
      #   libdisplay-info = pkgs.libdisplay-info_0_2;
      # };
    };

}
