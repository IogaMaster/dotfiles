{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.lutris;
in {
  options.apps.lutris = with types; {
    enable = mkBoolOpt false "Enable or disable lutris";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.lutris
    ];

    home.persist.directories = [
      ".local/share/lutris"
      ".cache/lutris"
    ];
  };
}
