{ lib }:
rec {
  findPackages =
    pkgsDir:
    let
      contents = builtins.readDir pkgsDir;
    in
    lib.listToAttrs (
      lib.flatten (
        lib.mapAttrsToList (
          name: type:
          if type == "directory" && builtins.pathExists (pkgsDir + "/${name}/default.nix") then
            [
              {
                inherit name;
                value = pkgsDir + "/${name}";
              }
            ]
          else if
            type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" && !(lib.hasPrefix "_" name)
          then
            [
              {
                name = lib.removeSuffix ".nix" name;
                value = pkgsDir + "/${name}";
              }
            ]
          else
            [ ]
        ) contents
      )
    );

  mkPackages =
    pkgs: pkgsDir: lib.mapAttrs (name: path: pkgs.callPackage path { }) (findPackages pkgsDir);
  mkOverlay = pkgsDir: (final: prev: { ioga = mkPackages final pkgsDir; });
}
