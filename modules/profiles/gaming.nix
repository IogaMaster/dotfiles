{ lib, pkgs, ... }@args:
lib.mkModule args "ioga.profiles.gaming" {
  config =
    { cfg }:
    {
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
