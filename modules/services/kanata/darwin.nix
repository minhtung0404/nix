{
  flake.modules.darwin.kanata =
    {
      self,
      kanata,
      config,
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ self.wrappers.kanata.install ];
      config = {
        system.activationScripts.postActivation.text = lib.mkOrder 1600 ''
          echo "-----------------------------------------------"
          echo "Permission required ..."
          echo "kanata: Please enable Input Monitoring/Accessibility for bash in ${lib.getExe config.wrappers.kanata.wrapper}"
        '';
        environment.launchDaemons =
          let
            startKanata = pkgs.writeScript "start-kanata" ''
              #!/usr/bin/env bash
              set -euo pipefail
              export LAPTOP=macair

              # Wait for the Karabiner VirtualHID daemon
              until pgrep -f Karabiner-VirtualHIDDevice-Daemon >/dev/null; do
                sleep 0.5
              done

              # Give DriverKit a moment to create the virtual device
              sleep 1


              exec -a "$0" ${lib.getExe config.wrappers.kanata.wrapper}
            '';
          in
          {
            "com.nixos.kanata.plist" = {
              enable = true;
              target = "com.nixos.kanata.plist";
              text = ''
                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                <dict>
                    <key>Label</key>
                    <string>com.nixos.kanata</string>
                    <key>EnvironmentVariables</key>
                    <dict>
                      <key>LAPTOP</key>
                      <string>macair</string>
                    </dict>
                    <key>ProgramArguments</key>
                    <array>
                      <string>${startKanata}</string>
                    </array>
                    <key>RunAtLoad</key>
                    <true/>
                    <key>StandardOutPath</key>
                    <string>/tmp/kanata.out.log</string>
                    <key>StandardErrorPath</key>
                    <string>/tmp/kanata.err.log</string>
                    <key>ProcessType</key>
                    <string>Interactive</string>
                </dict>
                </plist>
              '';
            };
            "com.nixos.karabiner.plist" = {
              enable = true;
              target = "com.nixos.karabiner.plist";
              text = ''
                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                <plist version="1.0">
                <dict>
                    <key>Label</key>
                    <string>com.nixos.karabiner</string>
                    <key>ProgramArguments</key>
                    <array>
                      <string>/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon</string>
                    </array>
                    <key>RunAtLoad</key>
                    <true/>
                    <key>ProcessType</key>
                    <string>Interactive</string>
                </dict>
                </plist>
              '';
            };
          };
      };
    };
}
