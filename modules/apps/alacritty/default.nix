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
  cfg = config.apps.alacritty;
in {
  options.apps.alacritty = with types; {
    enable = mkBoolOpt false "Enable or disable the alacritty terminal.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.alacritty];

    home.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
  };
}
