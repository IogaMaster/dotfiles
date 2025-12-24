{ lib, colors, pkgs, ... }@args:
lib.mkModule args "ioga.desktop.gdm" {
  config = { cfg }: {
    services.xserver.displayManager.gdm.enable = true;
    environment.persist.directories = [ "/etc/gdm" ];
  };
}
