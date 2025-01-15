{
  delib,
  inputs,
  pkgs,
  ...
}:
delib.module {
  name = "disko";

  options.disko = with delib; {
    enable = boolOption false;
    configuration = attrsOption { };
  };

  nixos.always.imports = [ inputs.disko.nixosModules.disko ];

  nixos.ifEnabled =
    { cfg, ... }:
    {
      disko = cfg.configuration;
      environment.systemPackages = [ inputs.disko.packages.${pkgs.system}.disko ];
    };
}
