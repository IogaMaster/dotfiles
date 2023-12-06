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
    custom.boscaceoil
    custom.mcman
  ];

  virtualisation.kvm.enable = true;

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;

    logo = ../../../.github/assets/flake.webp;
  };

  system.nix.extraUsers = [
    "hydra"
    "hydra-evaluator"
    "hydra-queue-runner"
  ];

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "23.11";
  # ======================== DO NOT CHANGE THIS ========================
}
