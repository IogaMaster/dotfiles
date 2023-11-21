{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.suites.desktop;
in {
  options.suites.desktop = with types; {
    enable = mkBoolOpt false "Enable the desktop suite";
  };

  config = mkIf cfg.enable {
    desktop.hyprland.enable = true;
    apps.firefox.enable = true;
    apps.discord.enable = true;

    apps.tools.gnupg.enable = true;
    apps.pass.enable = true;

    apps.kdeconnect.enable = true;

    suites.common.enable = true;

    services.flatpak.enable = true;

    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };

    environment.systemPackages = with pkgs; [
      cinnamon.nemo
      xclip
      xarchiver
    ];
  };
}
