{ lib, config, inputs, ... }@args:
(lib.mkModule args "colors" {
  options = with lib;
    with lib.types; {
      enable = mkBoolOpt' true; # enable by default
      scheme = mkOpt' str "catppuccin-mocha";
    };
  config = _: { };
}) // {
  # force a colors arg, kinda like passing into specialArgs, but from inside the modules system
  config._module.args.colors =
    inputs.nix-colors.colorSchemes.${config.colors.scheme}.palette;
}
