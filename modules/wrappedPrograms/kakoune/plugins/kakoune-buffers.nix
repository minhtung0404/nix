{
  flake.wrappers.kakoune = { config, pkgs, ... }: {
    config.plugins.kakoune-buffers = {
      src = pkgs.fetchFromGitHub {
        owner = "Delapouite";
        repo = "kakoune-buffers";
        rev = "6b2081f5b7d58c72de319a5cba7bf628b6802881";
        sha256 = "sha256-jOSrzGcLJjLK1GiTSsl2jLmQMPbPxjycR0pwF5t/eV0=";
      };
      activationScript = ''
        # Suggested hook

        hook global WinDisplay .* info-buffers

        # Suggested mappings

        map global user b ':enter-buffers-mode<ret>'              -docstring 'buffers…'
        map global normal ^ ':enter-buffers-mode<ret>'              -docstring 'buffers…'
        map global user B ':enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'

        # Suggested aliases

        alias global bd delete-buffer
        alias global bf buffer-first
        alias global bl buffer-last
        alias global bo buffer-only
        alias global bo! buffer-only-force
      '';
    };
  };
}
