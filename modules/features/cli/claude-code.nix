{
  den.aspects.claudeCode.homeManager =
    { lib, pkgs, ... }:
    {
      programs.claude-code = {
        enable = true;
        mutableSettings = true;
        settings = {
          theme = "auto";
          permissions.deny =
            map (p: "Edit(${p})") [
              "~/.bashrc"
              "~/.profile"
              "~/.bash_profile"
              "~/.claude/settings.json"
              "~/.claude/hooks/**"
            ]
            ++ map (p: "Read(${p})") [
              "**/.env*"
              "**/*.pem"
              "**/*.key"
              "**/secrets/**"
              "**/credentials/**"
              "**/.aws/**"
              "**/.ssh/**"
              "**/docker-compose*.yml"
              "**/config/database.yml"

              "~/Downloads/**"
              "~/Documents/encrypted/**"
              "~/.config/**"
              "~/.local/**"

              "~/.ssh/**"
              "~/.claude/.credentials.json"
              "~/.copilot/**"
              "~/.docker/**"
              "~/.kube/**"
              "~/.minikube/**"
              "~/.pki/**"
              "~/.bash_history"
              "~/.viminfo"
              "~/.steam/**"
              "~/.var/**"
              "~/.claude.json"
              "~/.pulse-cookie"

              "//run/secrets/**"
              "//run/secrets.d/**"
              "//etc/ssh/**"
              "//proc/**"
              "//run/user/**"
              "//run/media/**"
              "//run/libvirt/**"
              "//run/dbus/**"
              "//run/usbmuxd"
              "//var/lib/lockdown/**"
              "//run/ssh-unix-local/**"
            ]
            ++ lib.optional pkgs.stdenv.isDarwin "Read(~/Library/**)";
          sandbox = {
            enabled = true;
            autoAllowBashIfSandboxed = true;
            allowUnsandboxedCommands = false;
            failIfUnavailable = true;
            network.allowAllUnixSockets = true;
            filesystem.allowWrite = [ "~/.cache/nix" ];
          };
        };
      };
    };
}
