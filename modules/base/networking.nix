{
  delib,
  host,
  ...
}:
delib.module {
  name = "networking";

  options.networking = with delib; {
    nameservers = listOfOption str [
      "9.9.9.9"
    ];
    hosts = attrsOfOption (listOf str) { };
  };

  nixos.always =
    { cfg, ... }:
    {
      networking = {
        hostName = host.name;

        firewall.enable = true;
        networkmanager.enable = true;

        dhcpcd.extraConfig = "nohook resolv.conf";
        networkmanager.dns = "none";

        inherit (cfg) hosts nameservers;
      };

      user.extraGroups = [ "networkmanager" ];
    };
}
