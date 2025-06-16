{ lib, pkgs, ... }:
{
  home.activation = {
    "persistent-apps" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run --silence ${pkgs.dockutil}/bin/dockutil --remove all
      run --silence ${pkgs.dockutil}/bin/dockutil --add "${pkgs.librewolf}/Applications/LibreWolf.app/"
      run --silence ${pkgs.dockutil}/bin/dockutil --add "/System/Applications/Mail.app"
      run --silence ${pkgs.dockutil}/bin/dockutil --add "/System/Volumes/Data/Applications/VeraCrypt.app/"
      run --silence ${pkgs.dockutil}/bin/dockutil --add "${pkgs.obsidian}/Applications/Obsidian.app/"
    '';
  };
}
