{...}: {
  imports = [./hardware-configuration.nix];

  # Enable Bootloader
  system.boot.bios.enable = true;
  system.battery.enable = true;

  suites.desktop.enable = true;
  suites.development.enable = true;
  suites.editing.enable = true;

  impermanence.enable = true;

  topology.self = {
    hardware.info = "ThinkPad L430, 8GB RAM";
  };

  networking.interfaces.wlp6s0 = {
    name = "wlp6s0";
    useDHCP = true;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "22.11";
  # ======================== DO NOT CHANGE THIS ========================
}
