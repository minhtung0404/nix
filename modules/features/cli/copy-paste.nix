{
  den.aspects.copyPaste =
    { host, ... }:
    {
      homeManager =
        { lib, pkgs, ... }:
        {
          # Mimic the clipboard stuff in MacOS (wayland only)
          home.packages = lib.mkIf (host.class == "nixos") [
            (pkgs.writeShellScriptBin "pbcopy" ''
              exec ${pkgs.wl-clipboard}/bin/wl-copy "$@"
            '')
            (pkgs.writeShellScriptBin "pbpaste" ''
              exec ${pkgs.wl-clipboard}/bin/wl-paste "$@"
            '')
          ];
        };
    };
}
