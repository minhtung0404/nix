{
  flake.wrappers.kakoune =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options.lib = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };

      config.lib = {
        mkFacesScript' = faces: ''
          ${lib.concatStringsSep "\n" (
            builtins.attrValues (builtins.mapAttrs (name: face: "  face global ${name} \"${face}\"") faces)
          )}
        '';

        mkFacesScript = name: faces: {
          relPath = "share/kak/autoload/${name}/faces.kak";
          content = ''
            hook global KakBegin .* %{
            ${config.lib.mkFacesScript' faces}
            }
          '';
        };
      };
    };
}
