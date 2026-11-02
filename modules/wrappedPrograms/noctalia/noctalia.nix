{ config, ... }:
let
  inherit (config.mtn) images;
in
{
  # noctalia v5: config is TOML, read from $NOCTALIA_CONFIG_HOME/noctalia/*.toml.
  # GUI changes go to ~/.local/state/noctalia/settings.toml and override this.
  # Reference: https://docs.noctalia.dev/noctalia/configuration/
  flake.wrappers.noctalia =
    {
      config,
      lib,
      pkgs,
      wlib,
      ...
    }:
    let
      # the config dir is built into the wrapper's own output (constructFiles) and passed
      # as NOCTALIA_CONFIG_HOME; noctalia reads <it>/noctalia/*.toml and palettes/
      configDir = "noctalia-config/noctalia";
    in
    {
      imports = [ wlib.modules.default ];

      options = {
        settings = lib.mkOption {
          type = (pkgs.formats.toml { }).type;
          default = { };
          description = "noctalia config.toml, as a Nix attrset";
        };

        palettes = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Directory of custom palette JSON files, installed as palettes/; <name>.json is
            selected with theme.source = "custom" and theme.custom_palette = "<name>"
          '';
        };
      };

      config = {
        package = pkgs.noctalia;
        env.NOCTALIA_CONFIG_HOME = lib.removeSuffix "/noctalia/config.toml" config.constructFiles.noctaliaConfig.path;

        constructFiles = {
          # settings as JSON, turned into TOML and validated at build time;
          # `config validate` only warns (exit 0) about unknown settings, so
          # warnings fail the build too
          noctaliaConfig = {
            relPath = "${configDir}/config.toml";
            content = builtins.toJSON config.settings;
            builder = ''
              ${lib.getExe pkgs.remarshal} --from json --to toml "$1" "$2"
              result=$(${lib.getExe pkgs.noctalia} config validate "$2" 2>&1) || { echo "$result"; exit 1; }
              echo "$result"
              if grep -q WARN <<< "$result"; then exit 1; fi
            '';
          };
        }
        // lib.optionalAttrs (config.palettes != null) {
          # the whole palettes directory; the builder ignores $1 and copies the folder
          noctaliaPalettes = {
            relPath = "${configDir}/palettes";
            content = "";
            # noctalia silently falls back to its builtin palette for a palette whose
            # dark (or light, if present) variant has no `terminal` object
            builder = ''
              mkdir -p "$2"
              for palette in ${config.palettes}/*.json; do
                ${lib.getExe pkgs.jq} -e '
                  (.dark.terminal | type) == "object"
                  and ((has("light") | not) or (.light.terminal | type) == "object")
                ' "$palette" > /dev/null \
                  || { echo "$(basename "$palette"): every variant needs a terminal block"; exit 1; }
                cp "$palette" "$2/"
              done
            '';
          };
        };

        # every *.json in ./palettes, e.g. Selenized.json (https://github.com/jan-warchol/selenized;
        # light colors as in kakoune's selenized-light.kak). noctalia 5.2.1 needs a
        # `terminal` block in every variant, or it falls back to its builtin palette.
        palettes = ./palettes;

        settings = {
          shell = {
            font_family = "Sans Serif";
            # config comes from Nix: the first-run wizard would save its own theme
            # choice to ~/.local/state/noctalia/settings.toml, which overrides this
            setup_wizard_enabled = false;
            avatar_path = "${images.amira_squared}";

            launcher = {
              categories = true;
              sort_by_usage = true;
            };
            panel.launcher_position = "center";

            # v4 session menu: these six, 10 s countdown each (v5 has no
            # built-in hibernate, so it is a command entry)
            session.actions = map (a: a // { countdown_seconds = 10; }) [
              { action = "lock"; }
              { action = "suspend"; }
              {
                action = "command";
                label = "Hibernate";
                glyph = "snowflake";
                command = "systemctl hibernate";
              }
              { action = "reboot"; }
              { action = "logout"; }
              {
                action = "shutdown";
                variant = "destructive";
              }
            ];
          };

          osd = {
            position = "bottom_center";
            hide_delay_ms = 3000;
          };

          battery.warning_threshold = 20;

          # Selenized Light (palettes/Selenized.json)
          theme = {
            mode = "light";
            source = "custom";
            custom_palette = "Selenized";

            # recolor other apps with the palette (written to ~/.config at runtime):
            # gtk3/gtk4 add an @import to gtk-{3,4}.0/gtk.css; kcolorscheme merges into
            # kdeglobals, which Qt reads through the KDE platform theme (the qt5ct/qt6ct
            # "qt" template would be ignored); kitty keeps its own theme
            templates.builtin_ids = [
              "gtk3"
              "gtk4"
              "kcolorscheme"
            ];
          };

          # also the lock screen background ([lockscreen] wallpaper left empty)
          wallpaper = {
            enabled = true;
            fill_mode = "crop";
            default.path = "${images.mirai}";
          };

          bar.main = {
            position = "top";
            margin_ends = 0;
            margin_edge = 0;
            radius = 0;
            # bigger icons, spacing and text (the bar height is `thickness`, not scaled)
            scale = 1.5;
            start = [
              "control-center"
              "workspaces"
            ];
            center = [ "clock" ];
            end = [
              "notifications"
              "volume"
              "battery"
              "keyboard_layout"
              "tray"
            ];
          };

          widget = {
            clock.format = "{:%a, %b %d %H:%M}";
            # v4: workspace names, hide unoccupied ones
            workspaces = {
              label_source = "name";
              max_label_chars = 10;
              hide_when_empty = true;
            };
            # v4: volume shown as an icon only
            volume.show_label = false;
          };
        };
      };
    };
}
