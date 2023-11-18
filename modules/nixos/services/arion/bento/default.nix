{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.arion.bento;
in {
  options.services.arion.bento = with types; {
    enable = mkBoolOpt false "Enable bento";
  };

  config = mkIf cfg.enable {
    virtualisation.arion.enable = true;
    virtualisation.arion.projects.bento.settings = {
      project.name = "bento";
      services.filebrowser.service = {
        image = "lewisdoesstuff/bento";
        ports = [
          "80:80"
        ];
        volumes = [
          "${./config.js}:/usr/share/nginx/html/config.js"
        ];
      };
    };
  };
}
