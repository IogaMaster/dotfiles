{
  inputs,
  lib,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.profiles.gaming" {
  config =
    { cfg }:
    {

      nixpkgs.overlays = with inputs; [ nix-cachyos-kernel.overlays.pinned ];
      nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
      nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
      systemd.settings.Manager = {
        DefaultCPUAccounting = false;
        DefaultMemoryAccounting = false;
      };

      services.irqbalance.enable = true;

      boot.kernelParams = [ "nowatchdog" ];
      hardware.nvidia.powerManagement.enable = false;
      boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

      boot.loader.grub = {
        useOSProber = false;
      };

      programs.gamemode = {
        enable = true;
        enableRenice = false;
      };

      services.scx = {
        enable = true;
        scheduler = "scx_lavd";
        extraArgs = [ "--performance" ];
      };

      security.pam.loginLimits = [
        {
          domain = "*";
          type = "hard";
          item = "nofile";
          value = "1048576";
        }
        {
          domain = "*";
          type = "soft";
          item = "nofile";
          value = "1048576";
        }
      ];

      boot.kernel.sysctl = {
        # 1. ERADICATE PROTON STUTTERING: Turn off split lock performance penalties
        "kernel.split_lock_mitigate" = 0;

        # 2. OPTIMIZE RAM ACCESS: Keep assets inside your 16GB memory footprint longer
        "vm.swappiness" = 10;

        # 3. FILE SYSTEM MANAGEMENT: A generous limit that avoids engine handle crashes
        "fs.file-max" = 2097152;
      };

      environment.systemPackages = with pkgs; [
        prismlauncher
        # lutris # FIX: build failure
        heroic
        gamemode
        mangohud
        gamescope
        r2modman
      ];

      ioga.apps.steam.enable = true;
      powerManagement.cpuFreqGovernor = "performance";

      home.persist.directories = [
        ".config/r2modman"
        ".config/r2modmanPlus-local"
        ".var/app/at.vintagestory.VintageStory/"
        ".config/dztui"
        ".config/Olympus"
        ".local/share/lutris"
        ".local/share/aspyr-media"
        ".local/share/bottles"
        ".local/share/PrismLauncher"
        ".local/share/dzgui"
        ".factorio"
        "Games"
      ];
    };
}
