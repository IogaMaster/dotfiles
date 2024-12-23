{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.services.arion.windows;
in
{
  options.services.arion.windows = with types; {
    enable = mkBoolOpt false "Enable the windows docker service";
  };

  config = mkIf cfg.enable {
    virtualisation.arion.enable = true;
    virtualisation.arion.projects.windows.settings = {
      project.name = "windows";
      services.windows.service = {
        image = "dockurr/windows";
        environment.VERSION = "win11";
        ports = [
          "8006:8006"
          "3389:3389/tcp"
          "3389:3389/udp"
        ];
        devices = [ "/dev/kvm" ];
        capabilities = {
          NET_ADMIN = true;
        };
        stop_grace_period = "2m";
        volumes = [ "/home/${config.user.name}:/srv" ];
      };
    };
  };
}
