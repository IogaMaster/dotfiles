{ nixpkgs, ... }:
let
  inherit (nixpkgs) lib;
in
rec {
  mkLib = lib.extend (self: super:
    lib.attrsets.mergeAttrsList [
      (import ./hosts.nix { inherit lib; })
      (import ./modules.nix { inherit lib; })
      (import ./hardware.nix { inherit lib; })
      { inherit forAllSystems; }
    ]);

  forAllSystems = function:
    nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system:
      function (import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }));
}
