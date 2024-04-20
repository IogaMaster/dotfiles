{config, ...}: let
  inherit
    (config.lib.topology)
    mkInternet
    mkDevice
    mkSwitch
    mkRouter
    mkConnection
    ;
in {
  networks.home = {
    name = "Ground Zero";
    cidrv4 = "192.168.25.1/24";
  };

  nodes.internet = mkInternet {
    connections = mkConnection "router" "wan1";
  };

  nodes.router = mkRouter "linksys" {
    info = "Linksys0218";
    interfaceGroups = [
      ["eth1" "eth2"]
      ["wan1"]
    ];
    connections.eth1 = mkConnection "aurora" "enp0s31f6";
    connections.eth2 = mkConnection "equinox" "eno1";

    interfaces.eth1.network = "home";
    interfaces.eth2.network = "home";
  };
}
