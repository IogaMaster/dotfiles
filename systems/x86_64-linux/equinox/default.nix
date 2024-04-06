# Server for builds and binary cache (on prem)
{
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # Enable Bootloader
  system.boot.efi.enable = true;

  suites.server.enable = true;

  environment.systemPackages = with pkgs; [
    custom.mcman
  ];

  services.arion.filebrowser.enable = true;
  services.arion.terraria.vanilla.enable = true;

  impermanence.enable = true;

  topology.self = {
    hardware.info = "ThinkCentre, 16GB RAM";
  };

  networking.interfaces.eno1 = {
    name = "eno1";
    useDHCP = lib.mkDefault true;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
