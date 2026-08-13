{ self, ... }: {
  flake.wrappers.kitty =
    {
      config,
      pkgs,
      wlib,
      lib,
      ...

    }:
    {
      imports = [
        wlib.wrapperModules.kitty
      ];
      options = {
        # font
        fontSize = lib.mkOption {
          type = lib.types.int;
          description = "Font size";
          default = 16;
        };

        theme = lib.mkOption {
          type = lib.types.str;
          description = "kitty theme";
          default = "rose-pine-dawn";
        };

        mod = lib.mkOption {
          type = lib.types.str;
          description = "kitty mod";
          default = if pkgs.stdenv.isDarwin then "cmd+shift" else "alt+shift";
        };
      };

      config =
        let
          cfg = config;
        in
        {
          font = {
            # package = pkgs.nerd-fonts.fira-code;
            name = "FiraCode Nerd Font Mono";
            size = cfg.fontSize;
          };

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
          settings = {
            background_opacity = "0.85";
            dynamic_background_opacity = true;
            cursor_shape = "block";
            enable_audio_bell = false;
            hide_window_decorations = true;
            # editor = config.systemConstants.editor;

            allow_remote_control = true;
            listen_on = "unix:/tmp/mykitty";

            kitty_mod = cfg.mod;
            enabled_layouts = "fat:bias=70,splits,stack,tall:bias:60";
          };
          # shellIntegration.enableFishIntegration = true;
          themeFile = cfg.theme;
        };

    };
}
