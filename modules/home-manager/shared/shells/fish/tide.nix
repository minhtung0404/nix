{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.mtn.programs.my-fish.tide;
in
{
  options.mtn.programs.my-fish.tide = {
    enable = mkEnableOption "Enable tide integrations for fish";
    items = mkOption {
      type = types.attrsOf types.str;
      description = "Additional item definitions to create";
      default = { };
    };
    rightItems = mkOption {
      type = types.listOf types.str;
      description = "The list of right-items, note that `time` is not included here and will always appear last";
      default = [
        "status"
        "cmd_duration"
        "jobs"
        "direnv"
        "node"
        "python"
        "rustc"
        "java"
        "php"
        "pulumi"
        "ruby"
        "go"
        "gcloud"
        "kubectl"
        "distrobox"
        "toolbox"
        "terraform"
        "aws"
        "crystal"
        "elixir"
        "nix_shell"
      ];
    };
    leftItems = mkOption {
      type = types.listOf types.str;
      description = "The list of left-items. Note that `newline` and `character` is not included here and will always appear last";
      default = [
        "os"
        "context"
        "pwd"
        "git"
      ];
    };
  };

  config.programs.fish =
    let
      tideItems = attrsets.mapAttrs' (
        name: def: {
          name = "_tide_item_${name}";
          value = def;
        }
      );
    in
    mkIf cfg.enable {
      functions = tideItems (
        {
          nix_shell = ''
            # In a Nix Shell
            if set -qx DIRENV_FILE && test -f $DIRENV_FILE && rg -q "^use flake" $DIRENV_FILE
              set -U tide_nix_shell_color "FFA500"
              set -U tide_nix_shell_bg_color normal
              _tide_print_item nix_shell "❄"
            end
          '';
        }
        // cfg.items
      );
      plugins = [
        {
          name = "tide";
          src = pkgs.fishPlugins.tide.src;
        }
      ];
    };

  config.xdg.configFile."fish/tide/init.fish" = {
    text = ''
      # Configure tide items
      if test (count $argv) -gt 0
        tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_connection_andor_frame_color=Light --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
      end

      set -U tide_left_prompt_items ${
        concatMapStringsSep " " escapeShellArg cfg.leftItems
      } newline character
      set -U tide_right_prompt_items ${concatMapStringsSep " " escapeShellArg cfg.rightItems} time

      tide reload
    '';
  };
}
