{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.lutris;
in {
  options.apps.lutris = with types; {
    enable = mkBoolOpt false "Enable or disable lutris";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.lutris
      pkgs.fuse
    ];

    home.persist.directories = [
      ".local/share/lutris"
      ".cache/lutris"
      "Games"
    ];

    # Appimages for certain games
    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };
}
