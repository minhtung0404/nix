{ inputs, ... }: {
  flake-file.inputs = {
    treesitter-kanata = {
      url = "github:pbcdev210/treesitter-kanata";
    };
  };

  flake.wrappers.kakoune = { pkgs, ... }: {
    kak-tree-sitter.languages.kanata.package =
      inputs.treesitter-kanata.packages.${pkgs.stdenv.hostPlatform.system}.default;

    constructFiles.kanata = {
      relPath = "share/kak/on-load/kanata.kak";
      content = ''
        hook global BufCreate .*\.kbd$ %{
            set-option buffer filetype kanata
        }
      '';
    };
  };
}
