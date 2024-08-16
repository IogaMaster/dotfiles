{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.system.security.sudo;
in {
  options.system.security.sudo = {
    enable = mkBoolOpt false "";
  };

  config = mkIf cfg.enable {
    security.sudo.enable = true;
    security.sudo.wheelNeedsPassword = false;
  };
}
