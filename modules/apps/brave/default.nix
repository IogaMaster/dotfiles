{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.apps.brave;
in {
  options.apps.brave = with types; {
    enable = mkBoolOpt false "Enable or disable brave browser";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.brave];
  };
}
