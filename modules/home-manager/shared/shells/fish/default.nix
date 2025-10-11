{
  pkgs,
  config,
  options,
  lib,
  ...
}:
let
  user = config.mtn.username;
in
{
  imports = [
    ./launchd.nix
    ./tide.nix
  ];
  mtn.programs.my-fish.tide = {
    leftItems = options.mtn.programs.my-fish.tide.leftItems.default;
    rightItems = options.mtn.programs.my-fish.tide.rightItems.default;
  };
  programs.fish = {
    enable = true;

    # completions
    # vendor.completions.enable = true;
    generateCompletions = true;

    functions = {
      repair = {
        body = ''
          sudo nix-store --repair --verify --check-contents
        '';
        wraps = "nix-store";
      };

      flakify = {
        body = ''
          if ! test -f flake.nix
            echo "create flake.nix"
            nix flake init -t github:hercules-ci/flake-parts
          end
          if ! test -f .envrc
            echo "create .envrc"
            echo "use flake" > .envrc
            direnv allow
          end
        '';
      };

    };
    interactiveShellInit = ''
      set MANPATH "usr/local/man:$MANPATH"
      # set PATH "$HOME/.local/bin:/run/current-system/sw/bin/:/etc/profiles/per-user/${user}/bin/:$PATH"

      set fish_greeting # Disable greeting

      fish_vi_key_bindings
    '';
    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      # {
      #   name = "fzf-fish";
      #   src = pkgs.fishPlugins.fzf-fish;
      # }
    ];
    shellAliases = {
      "..." = "cd ../..";
      "...." = "cd ../../..";
      ls = "eza --hyperlink --group-directories-first --icons=auto";
      la = "ls -a";
      ll = "ls -lha";
      ld = "ls -lhaD";
      mkdir = "mkdir -p";
      e = "$EDITOR";
      se = "sudo e";
      c = "clear";
      v = "nvim";
      sv = "sudo nvim";
      mv = "mv -i";
      cp = "cp -i";
      ln = "ln -i";
      m = "make";
      lg = "lazygit";
      rgp = "rg --fixed-strings --ignore-case";

      cat = "bat";
    };
  };

  home.activation = {
    tideConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Running tide configure..."
      # run ${pkgs.fish}/bin/fish ~/.config/fish/tide/init.fish
    '';
  };
  home.packages = with pkgs; [
    fishPlugins.grc
    fishPlugins.plugin-git
  ];
}
