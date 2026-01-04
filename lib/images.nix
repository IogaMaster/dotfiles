{ lib, inputs, forAllSystems, pkgsForSystem, ... }:
with lib; {
  mkImages = imagesDir:
    { extraModules ? [ ], specialArgs ? { }, }:
    forAllSystems (system:
      let
        imageFiles =
          filterAttrs (image: t: t == "regular" && hasSuffix ".nix" image)
          (builtins.readDir imagesDir);
      in mapAttrs' (image: t: rec {
        name = removeSuffix ".nix" image;
        value = inputs.nixos-generators.nixosGenerate {
          inherit system specialArgs;
          modules = [ "${imagesDir}/${image}" ] ++ extraModules;
          format = name;
        };
      }) imageFiles);
}
