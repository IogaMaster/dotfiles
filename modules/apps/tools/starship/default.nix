{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.apps.tools.starship;
in {
  options.apps.tools.starship = with types; {
    enable = mkBoolOpt false "Enable starship";
  };

  config = mkIf cfg.enable {
    home.programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    environment.systemPackages = with pkgs; [
      starship
    ];

    home.configFile."starship.toml".source = ./starship.toml;
  };
}
