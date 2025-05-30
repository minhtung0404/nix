{ self, inputs }:
let
  myLib = (import ./default.nix) { inherit self inputs; };
  outputs = inputs.self.outputs;
in
rec {
  pkgsFor = sys: inputs.nixpkgs.legacyPackages.${sys};

  mkDarwin =
    sys: config:
    inputs.nix-darwin.lib.darwinSystem {
      system = sys;
      specialArgs = {
        inherit
          self
          inputs
          outputs
          myLib
          ;
      };
      modules = [
        config
        outputs.darwinModules.default
      ];
    };

  mkHome =
    sys: config:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor sys;
      extraSpecialArgs = {
        inherit
          self
          inputs
          myLib
          outputs
          ;
      };
      modules = [
        config
        outputs.homeManagerModules.default
        (
          { ... }:
          {
            nixpkgs = {
              config.allowUnfree = true;
              overlays = [ outputs.overlays.default ];
            };
          }
        )
      ];
    };

  filesIn = dir: (map (fname: dir + "/${fname}") (builtins.attrNames (builtins.readDir dir)));

  dirsIn =
    dir: inputs.nixpkgs.lib.filterAttrs (name: value: value == "directory") (builtins.readDir dir);

  filenameOf = path: (builtins.head (builtins.split "\\." (baseNameOf path)));

  # Evaluates nixos/home-manager module and extends it's options / config
  extendModule =
    { path, ... }@args:
    { pkgs, ... }@margs:
    let
      eval = if (builtins.isString path) || (builtins.isPath path) then import path margs else path margs;
      evalNoImports = builtins.removeAttrs eval [
        "imports"
        "options"
      ];

      extra =
        if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args) then
          [
            (
              { ... }:
              {
                options = args.extraOptions or { };
                config = args.extraConfig or { };
              }
            )
          ]
        else
          [ ];
    in
    {
      imports = (eval.imports or [ ]) ++ extra;

      options =
        if builtins.hasAttr "optionsExtension" args then
          (args.optionsExtension (eval.options or { }))
        else
          (eval.options or { });

      config =
        if builtins.hasAttr "configExtension" args then
          (args.configExtension (eval.config or evalNoImports))
        else
          (eval.config or evalNoImports);
    };

  # Applies extendModules to all modules
  # modules can be defined in the same way
  # as regular imports, or taken from "filesIn"
  extendModules =
    extension: modules:
    map (
      f:
      let
        name = filenameOf f;
      in
      (extendModule ((extension name) // { path = f; }))
    ) modules;

  extends = lib: config: type: name: {
    extraOptions = {
      mtn.${type}."my-${name}".enable = lib.mkEnableOption "enable my ${name} configuration";
    };

    configExtension = conf: (lib.mkIf config.mtn.${type}."my-${name}".enable conf);
  };

  forAllSystems =
    pkgs:
    inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ] (system: pkgs inputs.nixpkgs.legacyPackages.${system});
}
