{
  flake.wrappers.kakoune = { lib, pkgs, ... }: {
    config.kak-lsp.languageServers.nixd = {
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
