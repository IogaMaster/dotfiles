{
  delib,
  inputs,
  pkgs,
  ...
}:
let
  args = {
    ylib = inputs.nypkgs.lib.${pkgs.system};
    ypkgs = inputs.nypkgs.legacyPackages.${pkgs.system};
  };
in
delib.module {
  name = "nypkgs";

  nixos.always._module.args = args;
  home.always._module.args = args;
}
# Use this as an example of how to add package repos
