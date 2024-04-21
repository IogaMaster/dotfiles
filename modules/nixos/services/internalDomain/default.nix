{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.internalDomain;
in {
  options.services.internalDomain = with types; {
    enable = mkBoolOpt false "Enable dnsmasq, a custom internalDomain server";
    domain = mkOpt str "home.lan" "Internal Domain to use, defaults to home.lan";
    reverseProxyIp = mkOpt str "127.0.0.1" "IP address for the reverse proxy";
  };

  config =
    (mkIf cfg.enable {
      services.caddy.enable = true;

      services.caddy.virtualHosts."*.home.lan".extraConfig = ''
        tls internal
      '';

      networking.firewall.allowedTCPPorts = [53];
      networking.firewall.allowedUDPPorts = [53];

      services.dnsmasq = {
        enable = true;
        resolveLocalQueries = true;
        alwaysKeepRunning = true;
        settings = {
          server = ["9.9.9.9"];
          inherit (cfg) domain;
          local = "/${cfg.domain}/";

          bogus-priv = true;
          expand-hosts = true;
          no-hosts = true;
          domain-needed = true;
          no-resolv = true;
          no-poll = true;

          address = [
            "/${cfg.domain}/${cfg.reverseProxyIp}"
          ];
        };
      };
    })
    // {
    };
}
