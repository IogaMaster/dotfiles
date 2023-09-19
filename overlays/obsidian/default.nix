{channels, ...}: final: prev: {
  obsidan = with prev;
    makeDesktopItem {
      name = "Obsidian";
      desktopName = "Obsidian";
      genericName = "A note taking app";
      exec = ''
        ${obsidian}/bin/obsidian --use-gl=desktop
      '';
      icon = "obsidian";
      type = "Application";
      terminal = false;
    };
}
