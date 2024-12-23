{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.suites.server;
in
{
  options.suites.server = with types; {
    enable = mkBoolOpt false "Enable the server suite";
  };

  config = mkIf cfg.enable {
    suites.common.enable = true;
    suites.development.enable = true;
    environment.systemPackages = with pkgs; [ ];
  };
}
