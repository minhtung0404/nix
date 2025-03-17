{ config, pkgs, lib, ... }:
with lib;

let
  appleConfigFile = pkgs.writeTextFile {
    name = "kanata_apple.kbd";
    text = pkgs.lib.strings.concatStrings [
      (builtins.readFile ./default_configs/apple.kbd)
      (builtins.readFile ./default_configs/common.kbd)
      (builtins.readFile ./os_configs/macos.kbd)
    ];
  };
  gm610ConfigFile = pkgs.writeTextFile {
    name = "kanata_gm610.kbd";
    text = pkgs.lib.strings.concatStrings [
      (builtins.readFile ./default_configs/gm610.kbd)
      (builtins.readFile ./default_configs/common.kbd)
      (builtins.readFile ./os_configs/macos.kbd)
    ];
  };
in {
  environment.launchDaemons = {
    "com.nixos.kanata.plist" = {
      enable = true;
      target = "com.nixos.kanata.plist";
      text = ''
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>com.nixos.kanata</string>
            <key>ProgramArguments</key>
            <array>
              <string>${pkgs.kanata-with-cmd}/bin/kanata</string>
              <string>-c</string>
              <string>${appleConfigFile}</string>
              <string>-c</string>
              <string>${gm610ConfigFile}</string>
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

}
