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
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-livesplit-one
          input-overlay
        ];
      })
      audacity
      chromium
      inkscape
      mediainfo
      vhs
    ];

    # OBS
    boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    boot.kernelModules = [
      "v4l2loopback"
    ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;

    home.persist.directories = [
      ".config/obs-studio"
    ];
  };
}
