{ pkgs, config, ... }:
let
  user = config.mtn.username;
  hmLaunchdList = [ "sketchybar" "aerospace" ];
  loadBodyHmFn = load:
    pkgs.lib.concatMapStrings (name: ''
      case ${name}
        launchctl ${load} ~/Library/LaunchAgents/org.nix-community.home.${name}.plist
    '') hmLaunchdList;
  helperHm = pkgs.lib.concatMapStrings (name: "| ${name} ") hmLaunchdList;
  loadBody = load: ''
    switch $argv
      case "kanata"
        launchctl ${load} /Library/LaunchDaemons/com.nixos.kanata.plist
      ${loadBodyHmFn load}
      case "*"
        echo "Usages: lctl-${load} [ kanata ${helperHm}]"
    end
  '';
in {
  programs.fish = {
    enable = true;

    # completions
    # vendor.completions.enable = true;
    generateCompletions = true;

    functions = {
      rebuild = {
        body = ''
          darwin-rebuild switch --flake ~/.config/nix/
        '';
        wraps = "darwin-rebuild";
      };

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

      lctl-load = {
        body = loadBody "load";
        wraps = "launchctl";
      };

      lctl-unload = {
        body = loadBody "unload";
        wraps = "launchctl";
      };
    };
    interactiveShellInit = ''
      set MANPATH "usr/local/man:$MANPATH"
      set PATH "$HOME/.local/bin:/run/current-system/sw/bin/:/etc/profiles/per-user/${user}/bin/:$PATH"

      set fish_greeting # Disable greeting

      fish_vi_key_bindings

      # tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_connection_andor_frame_color=Light --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
    '';
    plugins = [
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
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
    };
  };
}
