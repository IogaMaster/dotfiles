{
  lib,
  colors,
  pkgs,
  secrets,
  ...
}@args:
lib.mkModule args "ioga.services.vaultwarden" {
  options = with lib; {
    consulServerAddresses = mkOpt' (types.listOf types.str) [ ];
  };
  config =
    { cfg }:
    {
      secrets.vaultwarden = { };
      services = {
        vaultwarden = {
          enable = true;
          config = {
            DOMAIN = "http://192.168.25.145:8222";
            ROCKET_ADDRESS = "0.0.0.0"; # Listen on all network interfaces
            ROCKET_PORT = 8222; # Default NixOS port for Vaultwarden
          };
        };

        consul = {
          enable = true;
          extraConfig = {
            server = false;
            retry_join = cfg.consulServerAddresses;
            bind_addr = ''{{ GetPrivateInterfaces | attr "address" }}'';
            services = lib.mkMerge [
              {
                name = "vaultwarden";
                port = 8222;
                tags = [ "public" ];
                check = {
                  http = "http://127.0.0.1:8222/alive";
                  interval = "10s";
                  timeout = "1s";
                };
              }
            ];
          };
        };

        restic.backups.vaultwarden = {
          initialize = true;
          environmentFile = "${secrets.vaultwarden}/environment";
          passwordFile = "${secrets.vaultwarden}/password";
          paths = [ "/var/lib/vaultwarden" ];

          timerConfig.OnCalendar = "hourly";
          pruneOpts = [
            "--keep-daily 7"
            "--keep-weekly 4"
            "--keep-monthly 6"
          ];
        };
      };

      # Open the firewall for the Vaultwarden port
      networking.firewall.allowedTCPPorts = [ 8222 ];
    };
}
