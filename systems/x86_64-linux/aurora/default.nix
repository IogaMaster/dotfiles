{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  # Enable Bootloader
  system.boot.efi.enable = true;

  suites.desktop.enable = true;
  suites.development.enable = true;
  suites.gaming.enable = true;
  suites.editing.enable = true;

  hardware.nvidia.enable = true;
  services.ssh.enable = true;
  environment.systemPackages = with pkgs; [
    custom.mcman

    inputs.dzgui.packages.x86_64-linux.dzgui
  ];

  # services.hydra = {
  #   enable = true;
  #   hydraURL = "http://localhost:3000";
  #   notificationSender = "hydra@localhost";
  #   buildMachinesFiles = [];
  #   useSubstitutes = true;
  #
  #   logo = ../../../.github/assets/flake.webp;
  # };
  #
  # system.nix.extraUsers = [
  #   "hydra"
  #   "hydra-evaluator"
  #   "hydra-queue-runner"
  # ];

  impermanence.enable = true;
  virtualisation.arion.enable = true;

  topology.self = {
    hardware.info = "ThinkStation, 32GB RAM";
  };

  networking.interfaces.enp0s31f6 = {
    name = "enp0s31f6";
    useDHCP = lib.mkDefault true;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "23.11";
  # ======================== DO NOT CHANGE THIS ========================
}
