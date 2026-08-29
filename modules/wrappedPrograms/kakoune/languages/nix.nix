{
  flake.wrappers.kakoune = { config, pkgs, ... }: {
    kak-tree-sitter.languages.nix = {
      package = pkgs.tree-sitter-grammars.tree-sitter-nix;
      queries = {
        src = config.kak-tree-sitter.src.helix;
        path = "runtime/queries/nix";
      };

    };

    kak-lsp.languageServers.nixd = {
      package = pkgs.nixd;
      filetypes = [ "nix" ];
      settings = {
        command = "nixd";
        root_globs = [
          "flake.nix"
          "shell.nix"
          ".git"
          ".hg"
        ];
      };
    };
  };
}
