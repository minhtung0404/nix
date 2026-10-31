{ config, ... }:
let
  inherit (config.mtn) workspaces nameToWorkspace;
in
{
  flake.wrappers.niri = { lib, ... }: {
    settings.workspaces =
      let
        workspaceConfig = lib.listToAttrs (
          map (w: {
            name = "${w.id} - ${w.name}";
            value = { };
          }) workspaces
        );
      in
      workspaceConfig;
    settings.binds = builtins.listToAttrs (
      builtins.concatMap (w: [
        {
          name = "Mod+${w.id}";
          value.focus-workspace = "${w.id} - ${w.name}";
        }
        {
          name = "Mod+Shift+${w.id}";
          value.move-column-to-workspace = "${w.id} - ${w.name}";
        }
      ]) workspaces
    );

    settings.window-rules = [
      # Workspace assignments
      {
        open-on-workspace = "${nameToWorkspace.web} - web";
        open-maximized = true;
        matches = [
          {
            at-startup = true;
            app-id = "^firefox$";
          }
          {
            at-startup = true;
            app-id = "^librewolf$";
          }
          {
            at-startup = true;
            app-id = "^zen$";
          }
          {
            at-startup = true;
            app-id = "^zen-beta$";
          }

        ];
      }
      {
        open-on-workspace = "${nameToWorkspace.chat} - chat";
        open-maximized = true;
        matches = [
          { title = "^((d|D)iscord|((A|a)rm(c|C)ord))$"; }
          { title = "VencordDesktop"; }
          { app-id = "VencordDesktop"; }
          { title = "vesktop"; }
          { app-id = "vesktop"; }

          { title = "Slack"; }
          { app-id = "Mattermost"; }
        ];
      }
      {
        open-on-workspace = "${nameToWorkspace.notes} - notes";
        open-maximized = true;
        matches = [
          { app-id = "md.Obsidian"; }
          { app-id = "md.obsidian.Obsidian"; }
          {
            app-id = "electron";
            title = ".*Obsidian.*";
          }
        ];
      }

    ];
  };
}
