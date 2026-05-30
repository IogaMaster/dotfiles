{ lib, pkgs, ... }@args:
lib.mkModule args "ioga.hardware.graphics" {
  config =
    { cfg }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-ocl
          intel-vaapi-driver

          libva-vdpau-driver
          libvdpau-va-gl
        ];
      };
    };
}
