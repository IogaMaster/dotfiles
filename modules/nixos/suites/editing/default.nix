{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.editing;
in {
  options.suites.editing = with types; {
    enable = mkBoolOpt false "Enable the editing suite";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obs-studio
      audacity
      openshot-qt
      mediainfo
      vhs
    ];

    # OBS
    boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    boot.kernelModules = [
      "v4l2loopback"
    ];
  };
}
