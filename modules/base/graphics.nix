{
  delib,
  host,
  lib,
  ...
}:
delib.module {
  name = "graphics";

  options.graphics = with delib; {
    enable = boolOption host.isDesktop;
    vendor = noDefault (
      enumOption [
        "nvidia"
        "amd"
        "intel"
      ] null
    );
  };

  nixos.ifEnabled =
    { cfg, ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    }
    // lib.mkIf (cfg.vendor == "nvidia") {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia.modesetting.enable = true;
      hardware.nvidia.open = false;
      environment = {
        variables = {
          CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        };
        shellAliases = {
          nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";
        };
        sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";
      };
    };

}
