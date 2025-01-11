# Server for builds and binary cache (on prem)
{
  lib,
  pkgs,
  inputs,
  config,
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
    name = "${hostJson.hostname}";
    hardware.info = "ThinkCentre, 16GB RAM";
  };

  # Enable Bootloader
  system.boot.efi.enable = true;
  suites.server.enable = true;
  impermanence.enable = false;
  networking = {
    interfaces.eno1 = {
      name = "eno1";
      ipv4.addresses = [
        {
          address = hostJson.ipv4;
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "192.168.25.1";
    firewall.enable = true;
  };

  services.jellyfin = {
    enable = true;
    cacheDir = "/mnt/media/cache";
    configDir = "/mnt/media/config";
    user = config.user.name;
    openFirewall = true;
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/65E8-C105";
    fsType = "exfat";
    options = [
      "users"
      "nofail"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/media/cache 0755 ${config.user.name} ${config.user.name} - -"
    "d /mnt/media/config 0755 ${config.user.name} ${config.user.name} - -"
  ];

  networking.firewall.allowedTCPPorts = [ 8096 ];

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
