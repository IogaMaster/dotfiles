{ lib, pkgs, ... }@args:
lib.mkModule args "ioga.hardware.graphics" {
  config = { cfg }: {
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-ocl
        intel-vaapi-driver
      ];
    };
  };
}
