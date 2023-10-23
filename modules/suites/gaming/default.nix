{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.suites.gaming;
in {
  options.suites.gaming = with types; {
    enable = mkBoolOpt false "Enable the gaming suite";
  };

  config = mkIf cfg.enable {
    apps.steam.enable = true;

    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-ocl
        vaapiIntel
      ];
    };

    environment.systemPackages = [
      pkgs.prismlauncher
      pkgs.lutris

      pkgs.gamemode
      pkgs.mangohud

      pkgs.gamescope

      pkgs.custom.relive
    ];
  };
}
