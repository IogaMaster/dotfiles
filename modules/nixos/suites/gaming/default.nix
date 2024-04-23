{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.gaming;
in {
  imports = with inputs; [
    dzgui-nix.nixosModules.default
  ];
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

    programs.dzgui.enable = true;

    environment.systemPackages = [
      pkgs.prismlauncher
      pkgs.lutris
      pkgs.heroic

      pkgs.gamemode
      pkgs.mangohud

      pkgs.gamescope

      pkgs.custom.relive

      pkgs.r2modman

      pkgs.bottles
    ];

    home.persist.directories = [
      ".config/r2modman"
      ".config/r2modmanPlus-local"
      ".config/dztui"
      ".local/share/lutris"
      ".local/share/bottles"
      ".local/share/PrismLauncher"
      ".local/share/dzgui"
      "Games"
    ];
  };
}
