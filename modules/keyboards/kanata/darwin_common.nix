{ config, pkgs, lib, environment, ... }:
let
  inherit (lib)
    mkIf mkEnableOption mkPackageOption mkOption listOf types literalExpression;
  cfg = config.minhtung0404.services.kanata;
in {
  environment.launchDaemons = let
    config_file = lib.strings.concatMapStrings (file: ''
      <string>-c</string>
      <string>${file}</string>
    '') config.minhtung0404.services.kanata.configFile;
  in mkIf cfg.enable {
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
              <string>${pkgs.kanata-with-cmd}/bin/kanata</string>
              ${config_file}
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
