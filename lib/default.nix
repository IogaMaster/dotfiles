{ nixpkgs, inputs, ... }:
let inherit (nixpkgs) lib;
in rec {
  mkLib = lib.extend (self: super:
    lib.attrsets.mergeAttrsList [
      { inherit forAllSystems pkgsForSystem pkgsAllSystems; }
      (import ./hosts.nix { inherit lib; })
      (import ./modules.nix { inherit lib; })
      (import ./hardware.nix { inherit lib; })
      (import ./images.nix { inherit lib inputs forAllSystems pkgsForSystem; })
    ]);

  forAllSystems = lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
  pkgsForSystem = system:
    import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  pkgsAllSystems = function:
    forAllSystems (system: function (pkgsForSystem system));
}
