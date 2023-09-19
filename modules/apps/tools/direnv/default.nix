{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.apps.tools.direnv;
in {
  options.apps.tools.direnv = with types; {
    enable = mkBoolOpt false "Enable direnv";
  };

  config = mkIf cfg.enable {
    home.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
