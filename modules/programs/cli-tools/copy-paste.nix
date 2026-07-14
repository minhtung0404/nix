{
  flake.modules.homeManager.copyPaste = { pkgs, ... }: {
    home.packages = [
      # Mimic the clipboard stuff in MacOS
      (pkgs.writeShellScriptBin "pbcopy" ''
        exec ${pkgs.wl-clipboard}/bin/wl-copy "$@"
      '')
      (pkgs.writeShellScriptBin "pbpaste" ''
        exec ${pkgs.wl-clipboard}/bin/wl-paste "$@"
      '')
    ];
  };
}
