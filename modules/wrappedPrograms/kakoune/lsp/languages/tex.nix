{
  flake.wrappers.kakoune = { pkgs, ... }: {
    kak-lsp.languageExtras = {
      latex.formatOnSave = false;
    };
    kak-lsp.languageServers = {
      texlab = {
        package = pkgs.texlab;
        filetypes = [ "latex" ];
        settings = {
          command = "texlab";
          root_globs = [
            "main.tex"
            "all.tex"
            "latexmkrc"
            ".latexmkrc"
            ".git"
          ];
          settings_section = "texlab";
          settings.texlab = {
            build.executable = "latexmk";
            build.args = [
              "-pdf"
              "-shell-escape"
              "-interaction=nonstopmode"
              "-synctex=1"
              "%f"
            ];

            build.forwardSearchAfter = true;
            build.onSave = true;

            forwardSearch = {
              executable = "okular";
              args = [
                "--unique"
                "file:%p#src:%l%f"
              ];
            };
          };
        };
      };

      ltex-ls-plus = {
        package = pkgs.ltex-ls-plus;
        filetypes = [
          "latex"
          "typst"
        ];
        settings = {
          command = "ltex-ls-plus";
          args = [ "--log-file=/tmp" ];
          root_globs = [
            "main.tex"
            "main.typ"
            "latexmkrc"
            ".latexmkrc"
            ".git"
          ];
        };
      };
    };
  };
}
