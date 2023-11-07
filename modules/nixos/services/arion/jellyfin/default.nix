{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.arion.jellyfin;
in {
  options.services.arion.jellyfin = with types; {
    enable = mkBoolOpt false "Enable jellyfin";
  };

  config = mkIf cfg.enable {
    virtualisation.arion.enable = true;
    virtualisation.arion.projects.jellyfin.settings = {
      project.name = "jellyfin";
      services.jellyfin = {
        service.image = "jellyfin/jellyfin";
        service.ports = [
          "8096:8096"
        ];
        service.volumes = [
          "/home/${config.user.name}/.local/share/jellyfin/config:/config"
          "/home/${config.user.name}/.local/share/jellyfin/cache:/cache"
          "/home/${config.user.name}/.local/share/jellyfin/media:/media"
        ];
      };
    };
  };
}
