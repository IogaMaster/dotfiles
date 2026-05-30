{
  lib,
  colors,
  pkgs,
  config,
  ...
}@args: # Added 'config' to the arguments
lib.mkModule args "ioga.desktop.gdm" {
  # FIXME: Apply: https://github.com/NixOS/nixpkgs/pull/523948
  # Wait for that to merge, as gdm is broken
  config =
    { cfg }:
    {
      services.displayManager.gdm.enable = true;
      environment.persist.directories = [ "/etc/gdm" ];

    };
}
