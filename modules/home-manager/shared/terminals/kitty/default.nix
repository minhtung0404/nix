{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mtn.programs.my-kitty;
  inherit (lib) types;
in
{
  imports = [ ./darwin.nix ];
  options.mtn.programs.my-kitty = {
    enable = lib.mkEnableOption "Enable kitty";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kitty;
    };

    # font
    fontSize = lib.mkOption {
      type = types.int;
      description = "Font size";
      default = 21;
    };

    background = lib.mkOption {
      type = types.nullOr types.path;
      description = "Path to the background image. If not set, default to a 0.9 opacity";
      default = null;
    };

    cmd = lib.mkOption {
      type = types.str;
      description = "The main control key";
      default = if pkgs.stdenv.isDarwin then "cmd" else "ctrl";
    };

    enableTabs = lib.mkOption {
      type = types.bool;
      description = "Enable tabs";
      default = pkgs.stdenv.isDarwin;
    };

    theme = lib.mkOption {
      type = types.str;
      description = "kitty theme";
      default = "rose-pine-dawn";
    };

    mod = lib.mkOption {
      type = types.str;
      description = "kitty mod";
      default = "cmd+shift";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      package = cfg.package;

      font = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
        size = cfg.fontSize;
      };

      settings =
        let
          # Background color and transparency
          background =
            if isNull cfg.background then
              {
                background_opacity = "0.85";
                dynamic_background_opacity = true;
              }
            else
              {
                background_image = "${cfg.background}";
                background_image_layout = "scaled";
                background_tint = "0.85";
              };
        in
        lib.mkMerge [
          background
          {
            cursor_shape = "block";
            enable_audio_bell = false;
            hide_window_decorations = true;
            editor = config.mtn.editor;
            dynamic_background_opacity = true;

            allow_remote_control = true;
            listen_on = "unix:/tmp/mykitty";

            kitty_mod = cfg.mod;
            enabled_layouts = "fat:bias=70,splits,stack,tall:bias:60";
          }
        ];

      keybindings = {
        "ctrl+c" = "copy_and_clear_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";

        "cmd+c" = "copy_and_clear_or_interrupt";
        "cmd+v" = "paste_from_clipboard";

        "kitty_mod+enter" = "new_window_with_cwd";
        "kitty_mod+n" = "new_os_window_with_cwd";

        "cmd+q" = "close_os_window";

        "ctrl+j" = "neighboring_window down";
        "ctrl+k" = "neighboring_window up";
        "ctrl+h" = "neighboring_window left";
        "ctrl+l" = "neighboring_window right";

        "f1" = "goto_layout splits";
        "f2" = "goto_layout fat";
        "f3" = "goto_layout tall";
        "f4" = "combine : launch --location=split : clear";

        "ctrl+t" = "combine : new_tab : clear";
        "cmd+t" = "combine : new_tab : clear";
      };

      shellIntegration.enableFishIntegration = true;
      themeFile = cfg.theme;
    };

    programs.fish = {
      shellAliases = {
        icat = "kitten icat";
      };
      shellInit = ''
        set -U fish_color_autosuggestion brblack
      '';
    };
  };
}
