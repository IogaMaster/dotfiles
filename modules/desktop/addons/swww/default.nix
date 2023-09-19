{
  options,
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.desktop.addons.swww;
in {
  options.desktop.addons.swww = with types; {
    enable = mkBoolOpt false "Enable or disable SWWW";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.swww
      (pkgs.writeShellScriptBin "wallpaper" ''
        /usr/bin/env ls ~/.config/theme/wallpapers/ | sort -R | tail -1 |while read file; do
            swww img ~/.config/theme/wallpapers/$file --transition-fps 255 --transition-type wipe
            echo "~/.config/theme/wallpapers/$file"
        done
      '')
    ];
  };
}
