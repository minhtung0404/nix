{ pkgs, ... }: {
  programs.kitty.enable = true;
  programs.kitty.darwinLaunchOptions =
    [ "--single-instance" "-o allow_remote_control=socket" ];
  programs.kitty.font = {
    package = pkgs.nerd-fonts.fira-code;
    name = "FiraCode Nerd Font Mono";
    size = 16;
  };

  programs.kitty.settings = {
    cursor_shape = "block";
    enable_audio_bell = false;
    hide_window_decorations = true;
    editor = "nvim";
    background_opacity = 0.9;
    dynamic_background_opacity = true;

    allow_remote_control = true;
    listen_on = "unix:/tmp/mykitty";

    kitty_mod = "cmd+shift";
    enabled_layouts = "splits,fat:bias=70,stack,tall:bias:60";
  };

  programs.kitty.keybindings = {
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

    "ctrl+b>minus" = "hsplit";
    "ctrl+b>kp_subtract" = "hsplit";
    "ctrl+b>shift+minus" = "vsplit";
    "ctrl+b>shift+kp_subtract" = "vsplit";
    "ctrl+b>plus" = "toggle_layout stack";

    "f1" = "goto_layout splits";
    "f2" = "goto_layout fat";
    "f3" = "goto_layout tall";
    "f4" = "combine : launch --location=split : clear";

    "shift+up" = "move_window up";
    "shift+left" = "move_window left";
    "shift+right" = "move_window right";
    "shift+down" = "move_window down";

    "cmd+t" = "combine : new_tab : clear";
  };

  programs.kitty.shellIntegration.enableFishIntegration = true;
  programs.kitty.themeFile = "rose-pine-dawn";
}
