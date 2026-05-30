{
  lib,
  pkgs,
  secrets,
  ...
}@args:
lib.mkModule args "ioga.services.vault" {
  options = with lib; {
    consulServerAddresses = mkOpt' (types.listOf types.str) [ ];
  };
  config =
    { cfg }:
    {
      systemd.services.vault.serviceConfig.EnvironmentFile = "/run/secrets/vault/environment"; # only way to get the secret into the service
      environment = {
        systemPackages = with pkgs; [ vault-bin ];
        persist.directories = [ "/run/secrets/vault" ];
        variables = {
          VAULT_ADDR = "https://vault.ioga.dev";
        };
      };

      services.vault = {
        enable = true;
        package = pkgs.vault-bin;
        address = "0.0.0.0:8200";
        storageBackend = "s3"; # actually cloudflare r2, but i cannot say that here
        storageConfig = # hcl
          ''
            bucket = "vault"
            region = "auto"
            s3_force_path_style = true
          '';
        extraConfig = # hcl
          ''
            ui = true
          '';
      };
      systemd.services.vault.environment = {
        VAULT_ADDR = "https://vault.ioga.dev";
      };

      services.consul = {
        enable = true;
        extraConfig = {
          server = false;
          retry_join = cfg.consulServerAddresses;
          bind_addr = ''{{ GetPrivateInterfaces | attr "address" }}'';
          services = lib.mkMerge [
            {
              name = "vault";
              port = 8200;
              tags = [ "public" ];
              check = {
                http = "http://127.0.0.1:8200/v1/sys/health";
                interval = "10s";
                timeout = "1s";
              };
            }
          ];
        };
      };

      networking.firewall.allowedTCPPorts = [ 8200 ];
    };
}
