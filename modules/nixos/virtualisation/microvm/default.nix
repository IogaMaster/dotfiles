{
  options,
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.virtualisation.microvm;
in
{
  imports = with inputs; [ microvm.nixosModules.host ];

  options.virtualisation.microvm = with types; {
    enable = mkBoolOpt false "Enable microvm support";
  };

  config = mkIf cfg.enable {
    environment.persist.directories = [ "/var/lib/microvms" ];
  };
}
