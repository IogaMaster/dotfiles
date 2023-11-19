{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.desktop.addons.swaync;
in {
  options.desktop.addons.swaync = with types; {
    enable = mkBoolOpt false "Enable or disable swaync";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swaync
      libnotify
    ];
  };
}
