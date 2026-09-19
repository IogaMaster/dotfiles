{
  lib,
  colors,
  pkgs,

  inputs,
  ...
}@args:
lib.mkModule args "ioga.apps.emacs" {
  imports = with inputs; [
    ewm.nixosModules.default
  ];
  config =
    { cfg }:
    {
      nixpkgs.overlays = [
        inputs.ewm.overlays.default
      ];

      programs.ewm.enable = true;

      home.persist.directories = [
        ".emacs.d"
      ];
    };
}
