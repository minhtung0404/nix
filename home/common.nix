{ config, pkgs, ... }:
 
{
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
 
  home.packages = with pkgs; [
    aerospace
    aldente
    coreutils
    curl
    discord
    eza
    fd
    hidden-bar
    htop
    jq
    kanata-with-cmd
    kitty
    neovim
    obsidian
    podman
    raycast
    ripgrep
    sketchybar-app-font
    stylua
    telegram-desktop
    thefuck
    vscode
    zoxide
    fishPlugins.grc
    fishPlugins.plugin-git
    grc
  ];

  programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character' --prompt_connection=Dotted --powerline_right_prompt_frame=No --prompt_connection_andor_frame_color=Light --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
      '';
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
        {
          name = "plugin-git";
          src = pkgs.fishPlugins.plugin-git.src;
        }
        {
            name = "tide";
            src = pkgs.fishPlugins.tide.src;
        }
      ];
      shellAliases = {
        ls    = "eza --hyperlink --group-directories-first --icons=auto";
        la    = "ls -a";
        ll    = "ls -lha";
        ld    = "ls -lhaD";
        mkdir = "mkdir -p";
        c     = "clear";
        v     = "nvim";
        vv    = "v .";
        sv    = "sudo nvim";
        mv    = "mv -i";
        cp    = "cp -i";
        ln    = "ln -i";
        m     = "make";
        lg    = "lazygit";
        rgp   = "rg --fixed-strings --ignore-case";
      };
  };

  programs.zoxide.enable = true;
  programs.zoxide.enableFishIntegration= true;
  programs.zoxide.options = [
    "--cmd j"
  ];


  # home.sessionVariables = {
  #   PATH = "/etc/profiles/per-user/${config.home.username}/bin:$PATH";
  # };
}
