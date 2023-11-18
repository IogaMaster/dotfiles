# Server for builds and binary cache (on prem)
{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  # Enable Bootloader
  system.boot.efi.enable = true;

  suites.server.enable = true;

  environment.systemPackages = with pkgs; [
    custom.mcman
  ];

  services.arion.filebrowser.enable = true;
  services.arion.bento.enable = true;

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
