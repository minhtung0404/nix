{
  flake.wrappers.kakoune =
    {
      config,
      pkgs,
      lib,
      wlib,
      ...
    }:
    {
      options = {
        kak-tree-sitter = lib.mkOption {
          type = lib.types.package;
          default = pkgs.kak-tree-sitter;
        };
      };

      config.plugins.kak-tree-sitter = {
        src = "${config.kak-tree-sitter}/ts.kak";
        wrapAsModule = true;
        activationScript = ''
          require-module kak-tree-sitter
        '';
      };

      config.runtimePkgs = [ config.kak-tree-sitter ];
    };
}
