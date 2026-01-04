{ lib, inputs, forAllSystems, pkgsForSystem, ... }:
with lib; {
  mkImages = imagesDir:
    { extraModules ? [ ], specialArgs ? { }, }:
    forAllSystems (system:
      let
        pkgs = pkgsForSystem system;
        imageFiles =
          filterAttrs (image: t: t == "regular" && hasSuffix ".nix" image)
          (builtins.readDir imagesDir);
        images = mapAttrs' (image: t: {
          name = removeSuffix ".nix" image;
          value = inputs.nixos-generators.nixosGenerate {
            inherit system specialArgs;
            modules = [ "${imagesDir}/${image}" ] ++ extraModules;
            format = removeSuffix ".nix" image;
          };
        }) imageFiles;
      in images);
}
