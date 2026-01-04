{ lib, pkgs, secrets, ... }@args:
lib.mkModule args "ioga.services.vault" {
  config = { cfg }: {
    environment.systemPackages = with pkgs; [ vault-bin ];

    environment.persist.directories = [ "/run/secrets/vault" ];
    systemd.services.vault.serviceConfig.EnvironmentFile =
      "/run/secrets/vault/environment"; # only way to get the secret into the service

    services.vault = {
      enable = true;
      package = pkgs.vault-bin;
      address = "0.0.0.0:8200";
      storageBackend =
        "s3"; # actually cloudflare r2, but i cannot say that here
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

    networking.firewall.allowedTCPPorts = [ 8200 ];
  };
}
