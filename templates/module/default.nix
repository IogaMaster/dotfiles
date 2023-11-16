{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.module;
in {
  options.module = with types; {
    enable = mkBoolOpt false "Enable module";
  };

  config =
    mkIf cfg.enable {
    };
}
