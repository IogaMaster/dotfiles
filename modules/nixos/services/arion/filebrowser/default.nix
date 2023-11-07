{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.services.arion.filebrowser;
in {
  options.services.arion.filebrowser = with types; {
    enable = mkBoolOpt false "Enable the filebrowser docker service";
  };

  config = mkIf cfg.enable {
    virtualisation.arion.enable = true;
    virtualisation.arion.projects.filebrowser.settings = {
      project.name = "filebrowser";
      services.filebrowser.service = {
        image = "filebrowser/filebrowser";
        ports = [
          "8080:80"
        ];
        volumes = [
          "/home/${config.user.name}:/srv"
        ];
      };
    };
  };
}
