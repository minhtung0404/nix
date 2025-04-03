{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.mtn.programs.my-kakoune;

  autoloadModule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description =
          "Name of the autoload script/folder. It might affect kakoune's load order.";
      };
      src = mkOption {
        type = types.path;
        description = "Path to the autoload script/folder.";
      };
      wrapAsModule = mkOption {
        type = types.bool;
        default = false;
        description =
          "Wrap the given source file in a `provide-module` command. Fails if the `src` is not a single file.";
      };
      activationScript = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description =
          "Add an activation script to the module. It will be wrapped in a `hook global KakBegin .*` wrapper.";
      };
    };
  };
in {
  imports = [ ./kak-lsp.nix ./tree-sitter.nix ];

  options.mtn.programs.my-kakoune = {
    enable = mkEnableOption "My version of the kakoune configuration";
    config.enable = mkEnableOption "Whether to enable kakoune config";
    package = mkOption {
      type = types.package;
      default = pkgs.kakoune;
      description = "The kakoune package to be installed";
    };
    autoload = mkOption {
      type = types.listOf autoloadModule;
      default = [ ];
      description = "Sources to autoload";
    };
    extraFaces = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra faces to include";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = lib.mkIf cfg.config.enable ({
      # kakrc
      "kak/kakrc".text = ''
        ${builtins.readFile ./kakrc}

        # Source any settings in the current working directory,
        # recursive upwards
        evaluate-commands %sh{
            ${
              pkgs.writeScript "source-pwd"
              (builtins.readFile ./scripts/source-pwd)
            }
        }

        # Load faces
        ${strings.concatStringsSep "\n" (builtins.attrValues
          (builtins.mapAttrs (name: face: ''face global ${name} "${face}"'')
            cfg.extraFaces))}
      '';

      "kak/colors" = {
        source = ./colors;
        recursive = true;
      };

      "kak/autoload/site-wide".source = "${cfg.package}/share/kak/autoload";
      "kak/autoload" = {
        source = ./autoload;
        recursive = true;
      };
    }
    # Custom autoload
      // (let
        kakouneAutoload =
          { name, src, wrapAsModule ? false, activationScript ? null }:
          [
            (if !wrapAsModule then {
              name = "kak/autoload/${name}";
              value.source = src;
            } else {
              name = "kak/autoload/${name}/module.kak";
              value.text = ''
                provide-module ${name} %◍
                  ${readFile src}
                ◍
              '';
            })
          ] ++ (if activationScript == null then
            [ ]
          else [{
            name = "kak/autoload/on-load/${name}.kak";
            value.text = ''
              hook global KakBegin .* %{
                ${activationScript}
              }
            '';
          }]);
      in builtins.listToAttrs
      (lib.lists.flatten (map kakouneAutoload cfg.autoload))));
  };
}

