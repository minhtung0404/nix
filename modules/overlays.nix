{ inputs, ... }: {
  flake.overlays.default = inputs.nixpkgs.lib.composeManyExtensions (
    let
      overlay-versioning = final: prev: { };

      overlay-libs = final: prev: { };
      overlay-packages = final: prev: { };
    in
    [
      overlay-versioning
      overlay-libs
      overlay-packages
      inputs.nur.overlays.default
      inputs.mtn-kakoune.overlays.default
    ]
  );
}
