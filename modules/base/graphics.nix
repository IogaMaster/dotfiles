{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "graphics";

  # options = delib.singleEnableOption host.isDesktop;

  options.graphics = with delib; {
    enable = host.isDesktop;
    vendor = enumOption [
      "nvidia"
      "amd"
      "intel"
    ];
  };

  nixos.ifEnabled = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

  };

}
