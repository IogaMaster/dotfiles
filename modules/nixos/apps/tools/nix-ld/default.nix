{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.tools.nix-ld;
in {
  options.apps.tools.nix-ld = with types; {
    enable = mkBoolOpt false "Enable nix-ld";
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
  };
}
