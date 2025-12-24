{ lib, colors, pkgs, ... }@args:
lib.mkModule args "ioga.services.vaultwarden" {
  config = { cfg }: {
    services.vaultwarden = {
      enable = true;
      # Use the full URL for the domain, including the protocol
      config = {
        DOMAIN = "http://192.168.25.145:8222";
        ROCKET_ADDRESS = "0.0.0.0"; # Listen on all network interfaces
        ROCKET_PORT = 8222; # Default NixOS port for Vaultwarden
      };
    };

    # Open the firewall for the Vaultwarden port
    networking.firewall.allowedTCPPorts = [ 8222 ];
  };
}
