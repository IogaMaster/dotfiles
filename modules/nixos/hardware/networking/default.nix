{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.hardware.networking;
in
{
  options.hardware.networking = with types; {
    enable = mkBoolOpt false "Enable networkmanager";
    interface = mkOpt str "Name of interface";
    staticIp = mkOpt str "Static ipv4 address";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    environment.persist.directories = [ "/etc/NetworkManager" ];

    networking.nameservers = [ "9.9.9.9" ];
  };
}
