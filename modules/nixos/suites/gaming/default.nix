{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.suites.gaming;
in
{
  imports = with inputs; [ ];
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
      pkgs.heroic
      # pkgs.custom.olympus # TODO: broken build for some reason

      pkgs.gamemode
      pkgs.mangohud

      pkgs.gamescope

      pkgs.custom.relive

      pkgs.r2modman
    ];

    services.flatpak.packages = [
      "at.vintagestory.VintageStory"
      "com.usebottles.bottles"
    ];

    home.persist.directories = [
      ".config/r2modman"
      ".config/r2modmanPlus-local"
      ".var/app/at.vintagestory.VintageStory/"
      ".config/dztui"
      ".config/Olympus"
      ".local/share/lutris"
      ".local/share/aspyr-media"
      ".local/share/bottles"
      ".local/share/PrismLauncher"
      ".local/share/dzgui"
      ".factorio"
      "Games"
    ];

    environment.persist.directories = [ "/var/lib/flatpak" ];
  };
}
