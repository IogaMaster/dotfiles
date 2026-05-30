{ lib, ... }:
with lib;
rec {
  ## Get nix modules recursively
  findModules =
    modulesDir:
    let
      findPaths =
        dir:
        lib.flatten (
          lib.mapAttrsToList (
            name: type:
            let
              path = dir + "/${name}";
            in
            if type == "directory" then
              findModules path
            else if type == "regular" && lib.hasSuffix ".nix" name && !(lib.hasPrefix "_" name) then
              path
            else
              [ ]
          ) (builtins.readDir dir)
        );
    in
    findPaths modulesDir;

  mkOpt =
    type: default: description:
    mkOption { inherit type default description; };
  mkOpt' = type: default: mkOpt type default null;
  mkBoolOpt = mkOpt types.bool;
  mkBoolOpt' = mkOpt' types.bool;
  mkEnableOpt = mkBoolOpt' false;

  mkModule =
    args: name:
    {
      imports ? [ ],
      options ? { },
      rawOptions ? { },
      config,
    }:
    let
      path = lib.splitString "." name;
      cfg = lib.attrByPath path { } args.config;
    in
    {
      inherit imports;
      options = (lib.setAttrByPath path ({ enable = mkEnableOpt; } // options)) // rawOptions;
      config = lib.mkIf (cfg.enable or false) (config {
        inherit cfg;
      });
    };
}
