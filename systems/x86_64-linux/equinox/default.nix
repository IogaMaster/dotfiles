# Server for builds and binary cache (on prem)
{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  hostJson = builtins.fromJSON (builtins.readFile ./host.tf.json);
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  topology.self = {
    name = "🍃 ${hostJson.hostname}";
    hardware.info = "ThinkCentre, 16GB RAM";
  };

  services.proxmox-ve = {
    enable = true;
    ipAddress = hostJson.ipv4;
  };

  # Enable Bootloader
  system.boot.efi.enable = true;
  suites.server.enable = true;
  impermanence.enable = true;
  networking = {
    bridges.vmbr0.interfaces = [ "eno1" ];
    interfaces.vmbr0 = {
      ipv4.addresses = [
        {
          address = hostJson.ipv4;
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "192.168.25.1";
    firewall.enable = false;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
