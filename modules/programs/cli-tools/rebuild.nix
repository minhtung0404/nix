{ ... }: {
  flake.modules.homeManager.rebuild = { lib, pkgs, ... }: {
    programs.fish.functions.rebuild = lib.mkMerge [
      (lib.mkIf pkgs.stdenv.isLinux {
        body = ''
          sudo nixos-rebuild switch --flake /etc/nixos
        '';
        wraps = "nixos-rebuild";
      })

      (lib.mkIf pkgs.stdenv.isDarwin {
        body = ''
          sudo darwin-rebuild switch --flake ~/.config/nix/
        '';
        wraps = "darwin-rebuild";
      })
    ];
  };
}
