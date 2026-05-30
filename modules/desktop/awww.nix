{
  lib,
  colors,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.desktop.awww" {
  config =
    { cfg }:
    {
      environment.systemPackages = [
        pkgs.awww
        (pkgs.writeShellScriptBin "wallpaper" ''
          /usr/bin/env ls ~/.config/wallpapers/ | sort -R | tail -1 |while read file; do
              awww img ~/.config/wallpapers/$file --transition-fps 255 --transition-type wipe
              echo "$file"
          done
        '')
      ];

      home.persist.directories = [ ".cache/awww" ];
    };
}
