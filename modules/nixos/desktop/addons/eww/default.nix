{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.eww;
in {
  options.desktop.addons.eww = with types; {
    enable = mkBoolOpt false "Enable or disable EWW.";
    wayland = mkBoolOpt false "Enable wayland support";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      eww-wayland

      playerctl
      gojq
      jaq
      socat
    ];

    home.configFile."eww/" = {
      recursive = true;
      source = ./config;
    };
  };
}
