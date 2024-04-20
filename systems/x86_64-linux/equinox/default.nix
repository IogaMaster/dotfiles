# Server for builds and binary cache (on prem)
{
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  topology.self = {
    name = "🍃 Equinox";
    hardware.info = "ThinkCentre, 16GB RAM";
  };

  # Enable Bootloader
  system.boot.efi.enable = true;
  suites.server.enable = true;
  impermanence.enable = true;

  networking.interfaces.eno1 = {
    name = "eno1";
    ipv4.addresses = [
      {
        address = "192.168.25.145";
        prefixLength = 24;
      }
    ];
  };

  networking.firewall.enable = false;

  services.internalDomain = {
    enable = true;
    reverseProxyIp = "192.168.25.145";
  };

  services.caddy.virtualHosts = {
    "jellyfin.home.lan".extraConfig = ''
      reverse_proxy http://192.168.25.106:8096
      tls internal
    '';

    "vaultwarden.home.lan".extraConfig = ''
      reverse_proxy :8012
      tls internal
    '';
  };

  services.vaultwarden = {
    enable = true;
    config = {
      webVaultEnabled = true;
      rocketAddress = "0.0.0.0";
      rocketPort = 8012;
      invitationOrgName = "Vaultwarden";
      domain = "https://vaultwarden.home.lan";
    };
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
