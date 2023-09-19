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
  cfg = config.desktop.addons.waybar;
in {
  options.desktop.addons.waybar = with types; {
    enable = mkBoolOpt false "Enable or disable waybar";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.waybar
    ];

    home.configFile."waybar/" = {
      recursive = true;
      source = ./config;
    };
  };
}
