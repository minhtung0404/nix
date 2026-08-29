{
  flake.wrappers.kakoune = { pkgs, ... }: {
    kak-tree-sitter.src = {
      helix = pkgs.helix-unwrapped.src;
      kak-tree-sitter = pkgs.kak-tree-sitter-unwrapped.src;
    };
  };
}
