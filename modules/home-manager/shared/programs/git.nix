{ config, ... }:
{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      "*.aux"
      "*.bll"
      "*.bcf"
      "*.blg"
      "*.fdb_latexmk"
      "*.fls"
      "*.log"
      "*.pdf"
      "*.run.xml"
      "*.synctex.gz"
      ".envrc"
      ".direnv"
      ".vscode"
    ];
    settings = {
      init = {
        defaultBranch = "main";
      };
      user = {
        name = "Minh Tung NGUYEN";
        email = "minhtung04042001@gmail.com";
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSetupRemote = true;
      };
      core = {
        editor = config.mtn.editor;
      };
    };
  };

}
