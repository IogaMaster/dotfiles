{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  hostJson = builtins.fromJSON (builtins.readFile ./host.tf.json);
in
{
  imports = [
    inputs.disko.nixosModules.disko
    (import "${inputs.self}/disks/impermanence.nix" {
      inherit lib;
      device = "/dev/nvme0n1";
    })
  ];
  hardware.facter.reportPath = ./facter.json;
  # # FIX: Currently broken, see: https://github.com/NixOS/nixpkgs/issues/485579
  # hardware.facter.detected.boot.graphics.kernelModules = lib.mkForce [ ];
  networking.hostName = hostJson.hostname;

  # With the new cooler, I can now up the wattage without overheating, this goes from 65w to 180w
  systemd.tmpfiles.settings."10-powercap" = {
    "/sys/class/powercap/intel-rapl/intel-rapl:0/constraint_0_power_limit_uw"."f+" = {
      argument = "180000000";
    };
    "/sys/class/powercap/intel-rapl/intel-rapl:0/constraint_1_power_limit_uw"."f+" = {
      argument = "180000000";
    };
  };

  impermanence.enable = true;

  ioga = {
    apps.recording.enable = true;
    hardware = {
      amd.enable = true;
      audio.enable = true;
      networking = {
        enable = true;
        interface = "eno1";
        staticAddress = hostJson.ipv4;
      };
    };
    apps.tools.git.enable = true;
    profiles.desktop.enable = true;
    profiles.gaming.enable = true;
  };

  system.stateVersion = "26.05";
}
