{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
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

      pkgs.r2modman
    ];

    home.persist.directories = [
      ".config/r2modman"
      ".config/r2modmanPlus-local"
      ".local/share/lutris"
    ];
  };
}
