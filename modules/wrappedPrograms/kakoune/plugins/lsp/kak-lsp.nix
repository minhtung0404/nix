{
  flake.wrappers.kakoune =
    {
      config,
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
