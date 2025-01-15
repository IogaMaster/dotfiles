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

  options.xdg = with delib; {
    enable = boolOption host.isDesktop;
  };

  home.always.imports = [ inputs.prism.homeModules.prism ];
}
