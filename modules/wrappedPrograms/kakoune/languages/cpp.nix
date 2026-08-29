{
  flake.wrappers.kakoune = { pkgs, ... }: {
    kak-tree-sitter.languages.cpp = {
      package = pkgs.tree-sitter-grammars.tree-sitter-cpp;
      helixSrc = "cpp";
    };

    kak-lsp.languageServers.clangd = {
      package = pkgs.clang-tools;
      filetypes = [
        "c"
        "cpp"
      ];
      settings = {
        command = "clangd";
        args = [ "--log=error" ];
        roots = [
          "compile_commands.json"
          ".clangd"
          ".git"
          ".hg"
        ];
      };
    };
  };
}
