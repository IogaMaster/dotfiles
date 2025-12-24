{ lib, config, pkgs, ... }@args:
lib.mkModule args "ioga.apps.discord" {
  config = { cfg }: {
    environment.systemPackages = [ pkgs.vesktop ];
    home.persist.directories = [ ".config/vesktop" ".config/discord" ];
  };
}
