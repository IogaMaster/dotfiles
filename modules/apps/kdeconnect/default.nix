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
  cfg = config.apps.kdeconnect;
in {
  options.apps.kdeconnect = with types; {
    enable = mkBoolOpt false "Enable or disable kdeconnect";
  };

  config = mkIf cfg.enable {
    programs.kdeconnect.enable = true;
  };
}
