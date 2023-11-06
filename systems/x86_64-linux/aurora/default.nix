{pkgs, ...}: {
  imports = [./hardware-configuration.nix];

  # Enable Bootloader
  system.boot.efi.enable = true;

  suites.desktop.enable = true;
  suites.development.enable = true;
  suites.gaming.enable = true;
  suites.editing.enable = true;

  hardware.nvidia.enable = true;
  services.ssh.enable = true;

  environment.systemPackages = with pkgs; [
    custom.blockbench
    custom.boscaceoil
    custom.mcman
  ];

  virtualisation.kvm.enable = true;

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  boot.swraid.enable = false;
  # ======================== DO NOT CHANGE THIS ========================
}
