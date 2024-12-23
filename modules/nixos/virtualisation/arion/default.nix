{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.virtualisation.arion;
in
{
  imports = with inputs; [ arion.nixosModules.arion ];

  options.virtualisation.arion = with types; {
    enable = mkBoolOpt false "Whether or not to enable arion, a docker-compose wrapper.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.arion
      pkgs.lazydocker
    ];
    virtualisation.arion.backend = "docker";
    virtualisation.docker.enable = true;

    environment.persist.directories = [ "/var/lib/docker" ];
  };
}
