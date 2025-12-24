{ lib, pkgs, options, config, inputs, ... }@args: {
  imports = with inputs; [
    vault-secrets.nixosModules.vault-secrets
    (lib.mkAliasOptionModule [ "secrets" ] [ "vault-secrets" "secrets" ])
  ];

  config = {
    vault-secrets = {
      vaultPrefix = "kv/servers/${config.networking.hostName}";
      vaultAddress = "http://192.168.25.145:8200";
    };

    nixpkgs.overlays = with inputs; [ vault-secrets.overlays.default ];
    environment.systemPackages = with pkgs; [
      vault
      (vault-push-approle-envs inputs.self)
      (vault-push-approles inputs.self)
    ];
  };

  # now you can use secrets.<any> anywhere
  config._module.args.secrets = config.vault-secrets.secrets;
}
