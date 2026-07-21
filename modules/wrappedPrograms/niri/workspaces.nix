{ self, ... }: {
  flake.wrappers.niri = { config, lib, ... }: {
    imports = [
      self.modules.generic.workspaces
    ];
    settings.workspaces =
      let
        workspaceConfig = lib.listToAttrs (
          map (w: {
            name = "${w.id} - ${w.name}";
            value = {
              open-on-output =
                if w.monitor == "secondary" then config.monitors.secondary else config.monitors.main;
            };
          }) config.mtn.workspaces
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
      ]) config.mtn.workspaces
    );

    settings.window-rules = [
      # Workspace assignments
      {
        open-on-workspace = "${config.mtn.nameToWorkspace.web} - web";
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
        open-on-workspace = "${config.mtn.nameToWorkspace.chat} - chat";
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
        open-on-workspace = "${config.mtn.nameToWorkspace.notes} - notes";
        open-maximized = true;
        matches = [
          { app-id = "obsidian"; }
          {
            app-id = "electron";
            title = ".*Obsidian.*";
          }
        ];
      }

    ];
  };
}
