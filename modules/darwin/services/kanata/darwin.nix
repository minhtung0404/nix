{ config, pkgs, lib, ... }:
let
  inherit (lib)
    mkIf mkEnableOption mkPackageOption mkOption listOf types literalExpression;
  cfg = config.mtn.services.my-kanata;
in {
  options.mtn.services.my-kanata = {
    enable = mkEnableOption "my-kanata";

    package = mkPackageOption pkgs "kanata-with-cmd" { };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression "[ pkgs.jq ]";
      description = ''
        Extra packages to add to PATH.
      '';
    };

    configFile = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = literalExpression ''[ "apple" ]'';
      description = ''
        path to the config
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.launchDaemons = let
      catString = lib.strings.concatMapStrings (name:
        let
          main = ./default_configs/${name}.kbd;
          common = ./default_configs/common.kbd;
        in ''
          cat ${main} ${common} > $out/${name}.kbd
        '') cfg.configFile;
      kanataConfig = pkgs.stdenv.mkDerivation {
        name = "kanata-config";
        phases = [ "installPhase" ];
        installPhase = ''
          mkdir -p $out
          ${catString}
        '';
      };
      configFiles = lib.strings.concatMapStrings (name: ''
        <string>-c</string>
        <string>${kanataConfig}/${name}.kbd</string>
      '') cfg.configFile;
    in {
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
                ${configFiles}
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
}

