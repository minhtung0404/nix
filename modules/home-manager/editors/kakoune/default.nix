{
  config,
  options,
  pkgs,
  lib,
  myLib,
  ...
}:

with lib;
let
  cfg = config.mtn.programs.my-kakoune;
  user = config.mtn.username;
in
{
  imports = [
    ./tree-sitter.nix
    ./fish-session.nix
  ] ++ (myLib.filesIn ./bundles);

  options.mtn.programs.my-kakoune = {
    enable = mkEnableOption "My version of the kakoune configuration";
    package = mkOption {
      type = types.package;
      default = pkgs.mtn-kakoune;
      description = "The kakoune package to be installed";
    };
    rc = mkOption {
      type = types.lines;
      default = "";
      description = "Content of the kakrc file. A line-concatenated string";
    };
    extraFaces = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Extra faces to include";
    };
    autoloadFile = mkOption {
      type = options.xdg.configFile.type;
      default = { };
      description = "Extra autoload files";
    };
    bundles = mkOption {
      type = types.str;
      default = "full";
      description = "Bundles to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile =
      let
        kakouneFaces =
          let
            txt = strings.concatStringsSep "\n" (
              builtins.attrValues (
                builtins.mapAttrs (name: face: ''face global ${name} "${face}"'') cfg.extraFaces
              )
            );
          in
          pkgs.writeText "faces.kak" txt;
      in
      {
        "kak/autoload/builtin".source = "${cfg.package}/share/kak/autoload";
        "kak/colors".source = ./colors;
        # kakrc
        "kak/kakrc".text = ''
          ${cfg.rc}

          # Load faces
          source ${kakouneFaces}

          set global grepcmd "rg --line-number --no-column --no-heading --follow --color=never "

          map global normal <a-[> ':inc-dec-modify-numbers - %val{count}<ret>'
          map global normal <a-]> ':inc-dec-modify-numbers + %val{count}<ret>'
          hook global KakBegin .* %{
            colorscheme catppuccin-latte
            set-option global peneira_files_command "fd -L ."
            define-command -override peneira-grep %{
              peneira 'line: ' %{ rg -L -n . . } %{
                lua %arg{1} %{
                  local file, line = arg[1]:match("([^:]+):(%d+):")
                  kak.edit(file, line)
                }
              }
            }
          }
        '';
      }
      // lib.mapAttrs' (name: attrs: {
        name = "kak/autoload/${name}";
        value = attrs // {
          target = "kak/autoload/${name}";
        };
      }) cfg.autoloadFile;
    xdg.dataFile."kak".source = "${cfg.package}/share/kak";
  };
}
