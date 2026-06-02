{
  lib,
  config,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.apps.recording" {
  config =
    { cfg }:
    {
      environment.systemPackages = with pkgs; [
        obs-studio
        obs-studio-plugins.wlrobs
      ];
    };
}
