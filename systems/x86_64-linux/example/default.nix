{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Enable Bootloader (EFI or BIOS)
  #system.boot.efi.enable = true;
  #system.boot.bios.enable = true;

  suites.desktop.enable = true;
  suites.development.enable = true;

  # Nvidia Drivers
  # hardware.nvidia.enable = true; 

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
