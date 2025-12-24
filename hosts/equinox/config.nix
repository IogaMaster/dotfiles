{ lib, inputs, ... }:
let hostJson = builtins.fromJSON (builtins.readFile ./host.tf.json);
in {
  imports = [
    inputs.disko.nixosModules.disko
    (import "${inputs.self}/disks/impermanence.nix" {
      inherit lib;
      device = "/dev/sda";
    })
  ];
  hardware.facter.reportPath = ./facter.json;

  networking.hostName = hostJson.hostname;

  ioga = {
    hardware = {
      audio.enable = true;
      networking = {
        enable = true;
        interface = "eno1";
        staticAddress = hostJson.ipv4;
      };
    };
    services = {
      vaultwarden.enable = true;
      vault.enable = true;
    };
    apps.tools.git.enable = true;
  };

  impermanence.enable = true;
}
