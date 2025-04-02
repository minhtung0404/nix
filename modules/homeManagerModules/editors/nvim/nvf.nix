{ pkgs, lib, ... }: {
  vim = {
    theme = {
      enable = true;
      name = "rose-pine";
      style = "dawn";
      transparent = false;
    };

    spellcheck.enable = true;

    lsp = {
      formatOnSave = true;
      lspkind.enable = false;
      lightbulb.enable = true;
      lspsaga.enable = false;
      trouble.enable = true;
      lspSignature.enable = true;
    };

    languages = {
      enableLSP = true;
      enableFormat = true;
      enableTreesitter = true;

      nix.enable = true;
    };

    visuals = {
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "solarized_light";
      };
    };

    autocomplete.nvim-cmp.enable = true;
    autopairs.nvim-autopairs.enable = true;
    snippets.luasnip.enable = true;
    tabline = { nvimBufferline.enable = true; };
    treesitter.context.enable = true;
    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope.enable = true;

    notify = { nvim-notify.enable = true; };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          # this is a freeform module, it's `buftype = int;` for configuring column position
          nix = "110";
          ruby = "120";
          java = "130";
          go = [ "90" "130" ];
        };
      };
      fastaction.enable = true;
    };

    comments = { comment-nvim.enable = true; };
  };
}
