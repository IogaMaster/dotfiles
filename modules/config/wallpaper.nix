{
  delib,
  inputs,
  lib,
  host,
  pkgs,
  ...
}:
delib.module {
  name = "wallpapers";

  options.wallpapers = with delib; {

  };

  home.always.imports = [ inputs.prism.homeModules.prism ];
}
