{ lib }:
lib.pkgsAllSystems (pkgs: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      (terraform.withPlugins (
        p: with p; [
          hashicorp_null
          hashicorp_external
          hashicorp_vault

          vultr_vultr
          oracle_oci
        ]
      ))
      jq

      # vault-bin

      statix
    ];
  };
})
