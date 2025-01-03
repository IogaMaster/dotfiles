{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.apps.steam;
in
{
  options.apps.steam = with types; {
    enable = mkBoolOpt false "Enable or disable steam";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;
    programs.steam.gamescopeSession.enable = true;

    environment.systemPackages = [
      pkgs.steam
      pkgs.mangohud
      pkgs.protonup
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${config.user.name}/.steam/root/compatibilitytools.d";
    };

    programs.gamemode.enable = true;

    home.persist.directories = [
      ".local/share/Steam"
      ".steam"

      ".local/share/Terraria"
      ".config/aseprite"
    ];
  };
}
