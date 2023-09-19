{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.apps.tools.nix-ld;
in {
  options.apps.tools.nix-ld = with types; {
    enable = mkBoolOpt false "Enable nix-ld";
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
  };
}
