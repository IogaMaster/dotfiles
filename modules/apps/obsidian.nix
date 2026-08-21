{
  lib,
  colors,
  pkgs,

  inputs,
  ...
}@args:
lib.mkModule args "ioga.apps.obsidian" {
  config =
    { cfg }:
    {
      environment.systemPackages = with pkgs; [
        obsidian
      ];

      home.persist.directories = [ ];
    };
}
