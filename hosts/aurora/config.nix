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
  # FIX: Currently broken, see: https://github.com/NixOS/nixpkgs/issues/485579
  hardware.facter.detected.boot.graphics.kernelModules = lib.mkForce [ ];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  networking.hostName = hostJson.hostname;

  impermanence.enable = true;

  ioga = {
    hardware = {
      nvidia.enable = true;
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
