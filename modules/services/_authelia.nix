{
  lib,
  secrets,
  colors,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.services.authelia" {
  options = with lib; {
    domain = mkOpt' types.str "ioga.dev";
    instanceName = mkOpt' types.str "main";
  };
  config =
    { cfg }:
    {
      secrets.authelia = {
        user = "authelia-${cfg.instanceName}";
        group = "authelia-${cfg.instanceName}";
      };

      services.authelia.instances.${cfg.instanceName} = {
        enable = true;

        secrets = {
          jwtSecretFile = "${secrets.authelia}/jwtSecretFile";
          sessionSecretFile = "${secrets.authelia}/sessionSecretFile";
          storageEncryptionKeyFile = "${secrets.authelia}/storageEncryptionKeyFile";
          oidcHmacSecretFile = "${secrets.authelia}/oidcHmac";
          oidcIssuerPrivateKeyFile = "${secrets.authelia}/oidcKey";
        };

        settings = {
          theme = "dark";
          server.address = "tcp://0.0.0.0:9091";

          authentication_backend.file.path = "${secrets.authelia}/users.yml";
          storage.local.path = "/var/lib/authelia-${cfg.instanceName}/db.sqlite3";
          notifier.filesystem.filename = "/var/lib/authelia-${cfg.instanceName}/emails.txt";

          access_control = {
            default_policy = "deny";
            rules = [
              {
                domain = "auth.${cfg.domain}";
                policy = "bypass";
              }
              {
                domain = "*.${cfg.domain}";
                policy = "one_factor";
              }
            ];
          };

          identity_providers.oidc = {
            clients = [
              {
                client_id = "vault";
                client_name = "HashiCorp Vault";
                public = false;
                client_secret = ''{{ secret "${secrets.authelia}/clientSecretHash" }}'';
                authorization_policy = "two_factor";
                redirect_uris = [
                  "https://vault.ioga.dev"
                  "http://localhost:8250/oidc/callback"
                ];
                scopes = [
                  "openid"
                  "profile"
                  "email"
                  "groups"
                ];
                userinfo_signed_response_alg = "none";
              }
            ];
          };

          session.cookies = [
            {
              inherit (cfg) domain;
              authelia_url = "https://auth.${cfg.domain}";
              default_redirection_url = "https://${cfg.domain}";
            }
          ];
        };
      };

      systemd.services."authelia-${cfg.instanceName}" = {
        serviceConfig.StateDirectory = "authelia-${cfg.instanceName}";

        # 4. Enable the 'template' filter via environment variable
        # This allows Authelia to process the {{ secret }} syntax in the config file.
        environment.X_AUTHELIA_CONFIG_FILTERS = "template";
      };
    };
}
