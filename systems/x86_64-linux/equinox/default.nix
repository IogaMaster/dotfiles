# Server for builds and binary cache (on prem)
{ lib, pkgs, ... }:
let
  hostJson = builtins.fromJSON (builtins.readFile ./host.terraform.json);
in
{
  imports = [ ./hardware-configuration.nix ];

  topology.self = {
    name = "🍃 Equinox";
    hardware.info = "ThinkCentre, 16GB RAM";
  };

  # Enable Bootloader
  system.boot.efi.enable = true;
  suites.server.enable = true;
  impermanence.enable = true;

  networking.interfaces.eno1 = {
    ipv4.addresses = [
      {
        address = "192.168.25.145";
        prefixLength = 24;
      }
    ];
  };

  networking.firewall.enable = false;

  boot.initrd.systemd.suppressedUnits = [ "systemd-machine-id-commit.service" ];
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
