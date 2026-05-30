{ lib, config, ... }@args:
lib.mkModule args "ioga.hardware.nvidia" {
  options =
    let
      hasNvidiaDevice = builtins.any (gpu: (gpu.vendor.hex or "") == "10de") (
        config.hardware.facter.report.hardware.graphics_card or [ ]
      );
    in
    with lib;
    with lib.types;
    {
      enable = mkBoolOpt' hasNvidiaDevice; # auto enable if nvidia card present
    };

  config =
    { cfg }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];
      boot.kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia-drm.fbdev=1"
        "initcall_blacklist=sysfb_init"
      ];
      hardware = {
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true;
          open = false;
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        };

      };
      environment = {
        variables = {
          CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        };
        shellAliases = {
          nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";
        };
        sessionVariables.WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.
      };
    };
}
