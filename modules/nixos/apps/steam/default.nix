{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.steam;
in {
  options.apps.steam = with types; {
    enable = mkBoolOpt false "Enable or disable steam";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;

    environment.systemPackages = [
      pkgs.steam
      (pkgs.makeDesktopItem {
        name = "Steam (Gamepad UI)";
        desktopName = "Steam (Gamepad UI)";
        genericName = "Application for managing and playing games on Steam.";
        categories = ["Network" "FileTransfer" "Game"];
        type = "Application";
        icon = "steam";
        exec = "steamos";
        terminal = false;
      })

      (pkgs.writeShellScriptBin "steamos" ''
        gamescope -W 1920 -H 1080  -w 1920 -h 1080 -e --adaptive-sync -- steam -gamepadui -steamdeck -steamos -fulldesktopres -tenfoot
      '')
    ];
  };
}
