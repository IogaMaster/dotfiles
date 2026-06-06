{
  lib,
  inputs,
  pkgs,
  ...
}@args:
lib.mkModule args "ioga.boot" {
  options =
    with lib;
    with lib.types;
    {
      enable = mkBoolOpt' true; # enable by default
      efi = mkBoolOpt' true;
    };
  config =
    { cfg }:
    {
      nixpkgs.overlays = [ inputs.mac-style-plymouth.overlays.default ];
      boot = {
        loader.grub = {
          enable = true;
          efiSupport = cfg.efi;
        };
        loader.efi.canTouchEfiVariables = lib.mkIf cfg.efi true;

        initrd.compressor = "zstd";
        initrd.compressorArgs = [ "-19" ];

        plymouth = {
          enable = true;
          theme = "mac-style";
          themePackages = [ pkgs.mac-style-plymouth ];
        };
      };
    };
}
