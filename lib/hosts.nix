{
  self,
  lib,
  mkLib,
  ...
}:
{
  makeSystems =
    systemsDir:
    {
      extraModules ? [ ],
      specialArgs ? { },
    }:
    builtins.listToAttrs (
      lib.lists.forEach
        (map (dir: dir) (
          builtins.attrNames (lib.filterAttrs (name: type: type == "directory") (builtins.readDir systemsDir))
        ))
        (system: {
          name = system;
          value = lib.nixosSystem {
            inherit specialArgs;
            modules = [
              "${systemsDir}/${system}/config.nix"
              (_: { nixpkgs.overlays = [ (mkLib.mkOverlay "${self}/pkgs") ]; })
            ]
            ++ extraModules;
          };
        })
    );
}
