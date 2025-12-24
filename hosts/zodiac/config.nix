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
        interface = "wlp6s0";
        staticAddress = hostJson.ipv4;
      };
      battery.enable = true;
    };
    boot.efi = false; # crusty laptop needs legacy boot
    apps.tools.git.enable = true;

    profiles.desktop.enable = true;
  };

  impermanence.enable = true;
}
