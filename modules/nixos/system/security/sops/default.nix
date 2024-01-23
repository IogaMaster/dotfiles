{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.custom; {
  imports = with inputs; [
    sops-nix.nixosModules.sops
  ];

  config = {
    sops.defaultSopsFile = ../../../../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";

    sops.age.keyFile = "/home/${config.user.name}/.config/sops/age/keys.txt";

    home.persist.directories = [
      ".config/sops"
    ];

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "sops" ''
        EDITOR=${config.environment.variables.EDITOR} ${pkgs.sops}/bin/sops $@
      '')
      age
    ];

    # List of defined secrets
    sops.secrets."ngrok/terraria" = {};
  };
}
