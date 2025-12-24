{ lib, config, pkgs, ... }@args:
lib.mkModule args "ioga.apps.steam" {
  config = { cfg }: {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
      };
      gamemode.enable = true;
    };
    environment = {
      systemPackages = [ pkgs.steam pkgs.mangohud pkgs.protonup-ng ];
      sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS =
          "/home/${config.user.name}/.steam/root/compatibilitytools.d";
      };
    };
    home.persist.directories = [
      ".local/share/Steam"
      ".steam"

      ".local/share/Terraria"
      ".config/aseprite"
    ];
  };
}
