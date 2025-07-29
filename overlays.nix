{ nixpkgs, ... }@inputs:
let
  overlay-versioning = final: prev: {
  };

  overlay-libs = final: prev: { libs.crane = inputs.crane.mkLib final; };
  overlay-packages = final: prev: {
  };
in
[
  overlay-versioning
  overlay-libs
  overlay-packages
  inputs.nur.overlays.default
  inputs.kakoune.overlays.default
]
