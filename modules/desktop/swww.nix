{ lib, colors, pkgs, ... }@args:
lib.mkModule args "ioga.desktop.swww" {
  config = { cfg }: {
    environment.systemPackages = [
      pkgs.swww
      (pkgs.writeShellScriptBin "wallpaper" ''
        /usr/bin/env ls ~/.config/wallpapers/ | sort -R | tail -1 |while read file; do
            swww img ~/.config/wallpapers/$file --transition-fps 255 --transition-type wipe
            echo "$file"
        done
      '')
    ];

    home.persist.directories = [ ".cache/swww" ];
  };
}
