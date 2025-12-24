{ lib, ... }@args:
lib.mkModule args "ioga.hardware.battery" {
  config = { cfg }: {
    services = {
      # Better scheduling for CPU cycles - thanks System76!!!
      system76-scheduler.settings.cfsProfiles.enable = true;
      # (better than gnomes internal power manager)
      tlp = {
        enable = true;
        settings = {
          CPU_BOOST_ON_AC = 0;
          CPU_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "powersave";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        };
      };
      # Disable GNOMEs power management
      power-profiles-daemon.enable = false;
      # (only necessary if on Intel CPUs)
      thermald.enable = true;
    };
    powerManagement.powertop.enable = true;
  };
}
