# Newer thinkpad
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Enable Bootloader
  system.boot.efi.enable = true;
  system.battery.enable = true;

  suites.desktop.enable = true;
  suites.development.enable = true;

  services.ssh.enable = true;

  apps.brave.enable = true;

  desktop.autoLogin = true;

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
