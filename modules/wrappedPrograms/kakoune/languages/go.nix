{
  flake.wrappers.kakoune = { config, pkgs, ... }: {
    kak-tree-sitter.languages.go = {
      # the grammar revision helix pins (its languages.toml), which its queries are
      # written for: nixpkgs' tree-sitter-go 0.25 renamed method_spec, and
      # kak-tree-sitter refuses the whole query set over one unknown node
      package = pkgs.tree-sitter.buildGrammar {
        language = "go";
        version = "0.19.1-unstable";
        src = pkgs.fetchFromGitHub {
          owner = "tree-sitter";
          repo = "tree-sitter-go";
          rev = "64457ea6b73ef5422ed1687178d4545c3e91334a";
          hash = "sha256-38pkqR9iEIEf9r3IHJPIYgKfWBlb9aQWi1kij04Vo5k=";
        };
      };
      queries = {
        src = config.kak-tree-sitter.src.helix;
        path = "runtime/queries/go";
      };
    };

    kak-lsp.languageServers.gopls = {
      package = pkgs.gopls;
      filetypes = [ "go" ];
      settings = {
        command = "gopls";
        root_globs = [
          "go.work"
          "go.mod"
          ".git"
          ".hg"
        ];
      };
    };

    # gopls runs the go command (go list, …) and does not bundle it; runtimePkgs are
    # appended to PATH, so a project's own go (direnv, devenv) still comes first
    runtimePkgs = [ pkgs.go ];
  };
}
