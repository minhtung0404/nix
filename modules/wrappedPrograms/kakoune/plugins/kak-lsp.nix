{
  flake.wrappers.kakoune =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      config.plugins.kak-lsp = {
        src = "${config.kak-lsp.package}/kak-lsp/";
        activationScript = ''
          require-module kak-lsp
        '';
      };

      config.runtimePkgs = [ config.kak-lsp.package ];
    };
}
