{
  lib,
  colors,
  pkgs,
  secrets,
  ...
}@args:
lib.mkModule args "ioga.services.reverse_proxy" {
  options = with lib; {
    domain = mkOpt' types.str "ioga.dev";
  };
  config =
    { cfg }:
    {

      ioga.services.authelia.enable = true;
      services = {
        resolved.extraConfig = ''
          [Resolve]
          DNS=127.0.0.1:8600
          Domains=~consul
        '';
        consul = {
          enable = true;
          extraConfig = {
            server = true;
            bootstrap_expect = 1;
            ui_config.enabled = true; # Access UI at http://localhost:8500
            bind_addr = ''{{ GetPrivateInterfaces | attr "address" }}'';
            client_addr = "0.0.0.0";
          };
        };

        caddy = {
          enable = true;
          extraConfig =
            #caddy
            ''
              (authelia_auth) {
                forward_auth 0.0.0.0:9091 {
                  uri /api/authz/forward-auth
                  copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
                  header_up X-Forwarded-Proto https # cloudflare tunnel gives http
                  header_up Host {host}
                }
              }
              (consul_router) {
                  reverse_proxy {
                      dynamic srv {
                          name "{labels.2}.service.consul"
                              resolvers 127.0.0.1:8600
                      }
                      transport http {
                          resolvers 127.0.0.1:8600
                      }
                      header_up Host {host}
                  }
              }
              http://auth.${cfg.domain} {
                reverse_proxy 0.0.0.0:9091
              }

              http://*.${cfg.domain} {
                import authelia_auth
                import consul_router
              }
            '';
        };
      };

      # consul firewall
      networking.firewall = {
        allowedTCPPorts = [
          8300
          8301
          8302
          8500
          8600
        ];
        allowedUDPPorts = [
          8301
          8302
          8600
        ];
      };
    };
}
