# Server for builds and binary cache (on prem)
{
  config,
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

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
